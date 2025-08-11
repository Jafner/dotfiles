{
  description = "Joey's Dotfiles";
  inputs = {
    # Package repositories:
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Applications:
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    catppuccin.url = "github:catppuccin/nix";
    ffaart.url = "github:Jafner/ffaart";
    nixcord.url = "github:KaylorBen/nixcord";
    fancontrol-gui.url = "github:Maldela/fancontrol-gui";
  };
  outputs = inputs @ {...}: {
    nixosConfigurations.desktop = let
      inherit inputs;
      username = "joey";
      hostname = "desktop";
      system = "x86_64-linux";
    in
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            username
            hostname
            system
            ;
        };
        modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          inputs.chaotic.nixosModules.default
          ./nixosConfigurations/desktop
        ];
      };
    nixosConfigurations.desktop-hyprland = let
      inherit inputs;
      username = "joey";
      hostname = "desktop";
      system = "x86_64-linux";
    in
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            username
            hostname
            system
            ;
        };
        modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          inputs.chaotic.nixosModules.default
          ./nixosConfigurations/desktop-hyprland
        ];
      };
    formatter.x86_64-linux =
      (inputs.treefmt-nix.lib.evalModule inputs.nixpkgs.legacyPackages.x86_64-linux {
        projectRootFile = "flake.nix";
        programs.nixpkgs-fmt.enable = true; # **.nix
        programs.deadnix.enable = true; # **.nix
      }).config.build.wrapper;
    checks.x86_64-linux = {
      pre-commit-check = inputs.pre-commit-hooks.lib.x86_64-linux.run {
        src = ./.;
        hooks = {
          nixpkgs-fmt.enable = true;
          deadnix.enable = true;
        };
      };
    };
  };
}
