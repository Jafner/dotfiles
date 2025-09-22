{username, ...}: {
  chaotic.mesa-git = {
    enable = false;
    fallbackSpecialisation = true;
  };
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };
  home-manager.users.${username} = {
    nixGL = {
      vulkan.enable = true;
      defaultWrapper = "mesa";
      installScripts = ["mesa"];
    };
  };
}
