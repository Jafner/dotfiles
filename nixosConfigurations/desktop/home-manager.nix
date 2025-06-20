{ inputs
, username
, system
, ...
}: {
  home-manager = {
    users."${username}" = {
      home.packages = [
        inputs.zen-browser.packages."${system}".default
      ];
    };
    backupFileExtension = "bak";
    extraSpecialArgs = { inherit inputs; };
    sharedModules = [
      inputs.stylix.homeModules.stylix
      inputs.chaotic.homeManagerModules.default
      inputs.nixcord.homeModules.nixcord
    ];
  };
}
