{
  username,
  pkgs,
  ...
}: {
  sops.secrets."bitwarden/client_id" = {
    sopsFile = ../../../secrets/my.secrets.yml;
    mode = "0440";
    owner = username;
  };
  sops.secrets."bitwarden/client_secret" = {
    sopsFile = ../../../secrets/my.secrets.yml;
    mode = "0440";
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
        lock_timeout = 172800; # 48 hours
        pinentry = pkgs.pinentry-qt;
      };
    };
    programs.zsh = {
      initContent = ''
        # Configure the official Bitwarden CLI client
        # eval "$(bw completion --shell zsh); compdef _bw bw;"
        # BW_STATUS="$(bw status | jq .status)"
        # if [[ "$BW_STATUS" == "unauthenticated" ]]; then
        #   BW_CLIENTID=$(cat /run/secrets/bitwarden/client_id) \
        #   BW_CLIENTSECRET=$(cat /run/secrets/bitwarden/client_secret) \
        #   bw login --apikey
        #   BW_STATUS="$(bw status | jq .status)"
        # fi
        # if [[ "$BW_STATUS" == "locked" ]]; then
        #   export BW_SESSION=$(bw unlock --raw)
        # fi

        # Configure rbw
        eval "$(rbw gen-completions zsh)"
        #rbw unlock
        #rbw sync
      '';
    };
  };
}
