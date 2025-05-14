{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    terranix.url = "github:terranix/terranix";
  };
  outputs = { self, nixpkgs, terranix, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      terraform = pkgs.terraform;
      terraformConfiguration = terranix.lib.terranixConfiguration {
        inherit system;
        modules = [ ./config.nix ];
      };
    in
  {
    defaultApp.${system} = self.apps.${system}.apply;
    apps.${system} = {
      apply = {
        type = "app";
        program = toString (pkgs.writers.writeBash "apply" ''
          if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
          cp ${terraformConfiguration} config.tf.json \
            && ${terraform}/bin/terraform init \
            && ${terraform}/bin/terraform apply
        '');
      };
      plan = {
        type = "app";
        program = toString (pkgs.writers.writeBash "plan" ''
          if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
          cp ${terraformConfiguration} config.tf.json \
            && ${terraform}/bin/terraform init \
            && ${terraform}/bin/terraform plan
        '');
      };
      destroy = {
        type = "app";
        program = toString (pkgs.writers.writeBash "destroy" ''
          if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
          cp ${terraformConfiguration} config.tf.json \
            && ${terraform}/bin/terraform init \
            && ${terraform}/bin/terraform destroy
        '');
      };
    };
    defaultPackage."${system}" = terranix.lib.terranixConfiguration {
      system = "${system}";
      modules = [ ./config.nix ];
    };
  };
}
