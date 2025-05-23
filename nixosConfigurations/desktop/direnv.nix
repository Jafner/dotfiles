{ username, ... }: {
  home-manager.users.${username} = {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      silent = true;
      nix-direnv.enable = true;
    };
  };
}
