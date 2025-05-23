{ pkgs
, username
, ...
}: {
  users.users."${username}".shell = pkgs.zsh;
  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
  home-manager.users."${username}" = {
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      zprof.enable = false;
      oh-my-zsh = {
        enable = true;
        theme = "lambda"; # Alt: "simple"
        plugins = [
          #aliases
          #alias-finder
          #bgnotify
          #branch
          #colored-man-pages
          #colorize
          #command-not-found
          #common-aliases
          #copybuffer
          #copyfile
          #copypath
          #cp
          #direnv
          #dirhistory
          #dirpersist
          #docker
          #docker-compose
          #dotenv
          #emoji
          #eza
          #fasd
          #fastfile
          #fzf
          #gh
          #git
          #git-auto-fetch
          #git-commit
          #gitfast
          #git-prompt
          #globalias
          #history
          #history-substring-search
          #magic-enter
          #pre-commit
          #rbw
          #ssh
          #ssh-agent
          #starship
          #terraform
          #wd
          #web-search
          #z
          #zoxide
          #zsh-interactive-cd
          #zsh-navigation-tools
        ];
      };
      history = {
        share = true;
        save = 10000;
        size = 10000;
        expireDuplicatesFirst = false;
        extended = false;
        ignoreAllDups = false;
        ignoreDups = true;
      };

      # envExtra -> ~/.config/zsh/.zshenv
      envExtra = ''

      '';
      # profileExtra -> ~/.config/zsh/.zprofile
      profileExtra = ''

      '';
      # initContent -> ~/.config/zsh/.zshrc
      # Loads each time an interactive shell is launched.
      initContent = ''
        DISABLE_AUTO_UPDATE="true"
        DISABLE_MAGIC_FUNCTIONS="true"
        DISABLE_COMPFIX="true"

        autoload -Uz compinit

        if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
          compinit
        else
          compinit -C
        fi

        bindkey '^[[1;5A' history-search-backward # Ctrl+Up-arrow
        bindkey '^[[1;5B' history-search-forward # Ctrl+Down-arrow
        bindkey '^[[1;5D' backward-word # Ctrl+Left-arrow
        bindkey '^[[1;5C' forward-word # Ctrl+Right-arrow
        bindkey '^[[H' beginning-of-line # Home
        bindkey '^[[F' end-of-line # End
        bindkey '^[w' kill-region # Delete
        bindkey '^I^I' autosuggest-accept # Tab, Tab
        bindkey '^[' autosuggest-clear # Esc
        bindkey -s '^E' 'ssh $(cat ~/.ssh/profiles | fzf --multi)\n'
        _fzf_compgen_path() {
            fd --hidden --exclude .git . "$1"
        }
        _fzf_compgen_dir() {
            fd --hidden --exclude .git . "$1"
        }
        eval "$(~/.nix-profile/bin/fzf --zsh)"

        fastfetch
      '';

    };
    home.packages = with pkgs; [
      zsh-completions
      nix-zsh-completions
    ];
  };
}
