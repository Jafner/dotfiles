{ username
, pkgs
, ...
}: {
  sops.secrets."bw/clientid" = {
    sopsFile = ./bw.clientid.token;
    mode = "0440";
    format = "binary";
    owner = username;
  };
  sops.secrets."bw/clientsecret" = {
    sopsFile = ./bw.clientsecret.token;
    mode = "0440";
    format = "binary";
    owner = username;
  };
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      rofi-rbw
      bitwarden-desktop
      bitwarden-cli
    ];
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      # theme = ''

      # '';
    };
    programs.rbw = {
      enable = true;
      settings = {
        base_url = "https://bitwarden.jafner.net";
        email = "jafner425@gmail.com";
        pinentry = pkgs.pinentry-qt;
      };
    };
    programs.zsh = {
      initContent = ''
        # Configure the official Bitwarden CLI client
        eval "$(bw completion --shell zsh); compdef _bw bw;"
        bw config server https://bitwarden.jafner.net
        BW_CLIENTID=$(cat /run/secrets/bw/clientid) \
        BW_CLIENTSECRET=$(cat /run/secrets/bw/clientsecret) \
        bw login --apikey
        export BW_SESSION=$(bw unlock --raw)

        # Configure rbw
        eval $(rbw gen-completions zsh)
        rbw unlock
        rbw sync
      '';
    };
  };
}
