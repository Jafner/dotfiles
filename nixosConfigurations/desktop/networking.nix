{...}: {
  systemd.network = {
    enable = true;
    networks = {
      "50-wan" = {
        address = [
          "192.168.0.200/24"
        ];
        dns = [
          "192.168.0.1"
        ];
        gateway = ["192.168.0.1"];
        matchConfig.Name = "enp4*";
        linkConfig.RequiredForOnline = "routable";
      };
      "60-tmp" = {
        address = ["192.168.0.43/24"];
        dns = ["192.168.0.1"];
        gateway = ["192.168.0.1"];
        matchConfig.Name = "enp7*";
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
  networking.useNetworkd = true;
  networking.hostName = "desktop";
  networking.firewall = {
    allowedTCPPorts = [25565];
    allowedUDPPorts = [25565];
  };
}
