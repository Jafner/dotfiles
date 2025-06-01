{ pkgs, username, ... }: {
  sops.secrets."cloudflare/r2/access_key_id" = {
    sopsFile = ../../../secrets/my.secrets.yml;
    mode = "0440";
    owner = username;
  };
  sops.secrets."cloudflare/r2/secret_access_key" = {
    sopsFile = ../../../secrets/my.secrets.yml;
    mode = "0440";
    owner = username;
  };
  sops.secrets."truenas/minio/desktop/access_key" = {
    sopsFile = ../../../secrets/my.secrets.yml;
    mode = "0440";
    owner = username;
  };
  sops.secrets."truenas/minio/desktop/secret_key" = {
    sopsFile = ../../../secrets/my.secrets.yml;
    mode = "0440";
    owner = username;
  };
  sops.secrets."truenas/versity/desktop/access_key" = {
    sopsFile = ../../../secrets/my.secrets.yml;
    mode = "0440";
    owner = username;
  };
  sops.secrets."truenas/versity/desktop/secret_key" = {
    sopsFile = ../../../secrets/my.secrets.yml;
    mode = "0440";
    owner = username;
  };

  systemd.services."mount-library-av" = {
    script = ''
      ${pkgs.rclone}/bin/rclone --no-check-certificate --config /home/${username}/.config/rclone/rclone.conf mount minio:library-av /mnt/minio/library-av
    '';
    serviceConfig.User = "${username}";
  };
  systemd.services."mount-recordings" = {
    script = ''
      ${pkgs.rclone}/bin/rclone --no-check-certificate --config /home/${username}/.config/rclone/rclone.conf mount minio:recordings /mnt/minio/recordings
    '';
    serviceConfig.User = "${username}";
  };
  home-manager.users.${username} = {
    home.packages = with pkgs; [ rclone-browser restic ];
    programs.zsh.initContent = ''
      eval $(${pkgs.restic}/bin/restic generate --zsh-completion -)
    '';
    programs.rclone = {
      enable = true;
      remotes = {
        versity = {
          config = {
            type = "s3";
            provider = "Other";
            env_auth = "true";
            endpoint = "https://192.168.1.10:30157";
          };
          secrets = {
            access_key_id = "/run/secrets/truenas/minio/desktop/access_key";
            secret_access_key = "/run/secrets/truenas/minio/desktop/secret_key";
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
            access_key_id = "/run/secrets/cloudflare/r2/access_key_id";
            secret_access_key = "/run/secrets/cloudflare/r2/secret_access_key";
          };
        };
        minio = {
          config = {
            type = "s3";
            provider = "Minio";
            env_auth = "true";
            region = "auto";
            endpoint = "https://192.168.1.12:9000";
          };
          secrets = {
            access_key_id = "/run/secrets/truenas/minio/desktop/access_key";
            secret_access_key = "/run/secrets/truenas/minio/desktop/secret_key";
          };
        };
      };
    };
  };
}
