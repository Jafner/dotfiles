{ pkgs, username, ... }: {
  home-manager.users.${username} = {
    home.packages = [
      pkgs.caddy
    ];
  };
  services.caddy = {
    enable = false;
    user = "${username}";
    group = "users";
    email = "joey@jafner.net";
    logDir = "/var/log/caddy";
    dataDir = "/var/lib/caddy";
    enableReload = true;
    acmeCA = "https://acme-staging-v02.api.letsencrypt.org/directory";
    virtualHosts = {

    };
  };
}
