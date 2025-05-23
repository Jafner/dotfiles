{ pkgs, username, ... }: {
  sops.secrets."cloudflare/r2/access_key_id" = {
    sopsFile = ../../../secrets/my.secrets.yml;
    mode = "0440";
    owner = username;
    # to update:
    # rbw get "Cloudflare API" --field "R2 Access Key ID" | sops encrypt --filename-override r2.access_key_id.token > $HOME/Git/dotfiles/nixosConfigurations/desktop/filesync/r2.access_key_id.token
  };
  sops.secrets."cloudflare/r2/secret_access_key" = {
    sopsFile = ../../../secrets/my.secrets.yml;
    mode = "0440";
    owner = username;
    # to update:
    # rbw get "Cloudflare API" --field "R2 Secret Access Key" | sops encrypt --filename-override r2.secret_access_key.token > $HOME/Git/dotfiles/nixosConfigurations/desktop/filesync/r2.secret_access_key.token
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
  systemd.services."rclone-sync" = {
    script = ''
      ${pkgs.rclone}/bin/rclone sync "/home/${username}/My Data/" r2:personal/
    '';
    serviceConfig = {
      User = "${username}";
    };
    startAt = [ "*-*-* 05:00:00" ];
  };
  security.pki.certificates = [
    ''
      192.168.1.12
      ============
      -----BEGIN CERTIFICATE-----
      MIIDrTCCApWgAwIBAgIEOGpA8jANBgkqhkiG9w0BAQsFADCBgDELMAkGA1UEBhMC
      VVMxEjAQBgNVBAoMCWlYc3lzdGVtczESMBAGA1UEAwwJbG9jYWxob3N0MSEwHwYJ
      KoZIhvcNAQkBFhJpbmZvQGl4c3lzdGVtcy5jb20xEjAQBgNVBAgMCVRlbm5lc3Nl
      ZTESMBAGA1UEBwwJTWFyeXZpbGxlMB4XDTI0MDcwOTE5NDIwOFoXDTI1MDgxMDE5
      NDIwOFowgYAxCzAJBgNVBAYTAlVTMRIwEAYDVQQKDAlpWHN5c3RlbXMxEjAQBgNV
      BAMMCWxvY2FsaG9zdDEhMB8GCSqGSIb3DQEJARYSaW5mb0BpeHN5c3RlbXMuY29t
      MRIwEAYDVQQIDAlUZW5uZXNzZWUxEjAQBgNVBAcMCU1hcnl2aWxsZTCCASIwDQYJ
      KoZIhvcNAQEBBQADggEPADCCAQoCggEBAOaaaDEVtLg6P5mFq80TQdzc1puH+b/N
      3FpV3v9D6OIJfvBb3nBT6SP1gB+uMXGscF1q3gk7cLYVJwDC3sxd9A5juSQJFaT/
      UYBARXcwJQKZvSDfm/jWi9VFKClSnMZyZV1ftq9RKFI+phejU0JNHD/8JwxMn9Ye
      +z5hkmgPCEOgcHEDDpE/NuO0rodBfQQL/tjwcXN/XquS/fcS/p84WQ7VrPNM/B4H
      7UqX8fxLy6ThWz7ugcKc+BcPRcem8A5X0GjwWMVOOkwI1FZOKT/mAZIstw7bYeVx
      xAZxk9OwnanbsMuyBpe1NAkoGV8q+0GOcanluDqv52rmzVCuU3EwDiUCAwEAAaMt
      MCswFAYDVR0RBA0wC4IJbG9jYWxob3N0MBMGA1UdJQQMMAoGCCsGAQUFBwMBMA0G
      CSqGSIb3DQEBCwUAA4IBAQCqJpmWVyHdoTnQef1YqLiaHSxm7uLJmlXbQOIfu/Ar
      YG+a9UCRSp8DMGNeGoDEZgpVwEydqViqWzV7xwuOcBHB6SjvCvM4jC3NI8wvV2fV
      NF7ru5IloI/Hxp3dS3y3T2F+uLyXBA354z1HpFD26HZdzpcdea2B+KZfWKuBEpmh
      ZtR/AHFPrCbMuHBGNF0TXxRSJKeIgTsZFcRDSI62fhF5zn534hnT2jxB7X/qxrUd
      Ej2vkZza67ahbezo5SdFB90X0lxFx2ch1q3/fKDY8zCzU/6lzLwLtCnikhOorlr+
      eMk16qawmUnKjT0TPX/c+3OryqQIsNLGdaGxd3G9ZtSQ
      -----END CERTIFICATE-----
    ''
  ];
  home-manager.users.${username} = {
    home.packages = with pkgs; [ rclone-browser restic ];
    programs.zsh.initContent = ''
      eval $(${pkgs.restic}/bin/restic generate --zsh-completion -)
    '';
    programs.rclone = {
      enable = true;
      remotes = {
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
