{ pkgs, username, ... }: {
  sops.secrets."s3/access_key_id" = {
    sopsFile = ./s3.access_key_id.token;
    mode = "0440";
    format = "binary";
    owner = username;
  };
  sops.secrets."s3/secret_access_key" = {
    sopsFile = ./s3.secret_access_key.token;
    mode = "0440";
    format = "binary";
    owner = username;
  };
  sops.secrets."r2/access_key_id" = {
    sopsFile = ./r2.access_key_id.token;
    mode = "0440";
    format = "binary";
    owner = username;
  };
  sops.secrets."r2/secret_access_key" = {
    sopsFile = ./r2.secret_access_key.token;
    mode = "0440";
    format = "binary";
    owner = username;
  };
  systemd.services."rclone-sync" = {
    script = ''
      ${pkgs.rclone}/bin/rclone sync "/home/${username}/My Data/" r2:personal/
    '';
    serviceConfig = {
      User = "${username}";
    };
    startAt = [ "*-*-* 05:00:00" ];
  };
  home-manager.users.${username} = {
    home.packages = with pkgs; [ rclone-browser restic ];
    programs.zsh.initContent = ''
      eval $(${pkgs.restic}/bin/restic generate --zsh-completion -)
    '';
    programs.rclone = {
      enable = true;
      remotes = {
        s3 = {
          config = {
            type = "s3";
            provider = "AWS";
            env_auth = "true";
            region = "us-west-2";
            location_constraint = "us-west-2";
          };
          secrets = {
            access_key_id = "/run/secrets/s3/access_key_id";
            secret_access_key = "/run/secrets/s3/secret_access_key";
          };
        };
        r2 = {
          config = {
            type = "s3";
            provider = "Cloudflare";
            env_auth = "true";
            region = "auto";
            endpoint = "https://9c3bc49e4d283320f5df4fc2e8ed9acc.r2.cloudflarestorage.com";
          };
          secrets = {
            access_key_id = "/run/secrets/r2/access_key_id";
            secret_access_key = "/run/secrets/r2/secret_access_key";
          };
        };
      };
    };
  };
}
