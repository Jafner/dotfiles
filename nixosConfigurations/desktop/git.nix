{username, ...}: {
  home-manager.users.${username} = {
    programs.git = {
      enable = true;
      settings = {
        user.name = "Joey Hafner";
        user.email = "joey@jafner.net";
        user.signingKey = "/home/${username}/.ssh/joey.desktop@jafner.net.pub";
        init.defaultBranch = "main";
        core.sshCommand = "ssh -i $HOME/.ssh/joey.desktop@jafner.net";
        gpg.format = "ssh";
        commit.gpgsign = true;
        tag.gpgsign = true;
      };
    };
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options.side-by-side = true;
    };
  };
}
