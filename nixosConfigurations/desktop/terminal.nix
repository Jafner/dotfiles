{ pkgs
, username
, ...
}: {
  home-manager.users.${username} = {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      installBatSyntax = true;
      clearDefaultKeybinds = false;
    };
    programs.kitty.enable = true;
    programs.tmux = {
      enable = true;
      newSession = true;
      baseIndex = 1;
      disableConfirmationPrompt = true;
      mouse = true;
      prefix = "C-b";
      resizeAmount = 2;
      plugins = with pkgs; [
        { plugin = tmuxPlugins.resurrect; }
        { plugin = tmuxPlugins.tmux-fzf; }
      ];
      shell = "${pkgs.zsh.shellPath}";
    };
  };
}
