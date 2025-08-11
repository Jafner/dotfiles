{...}: {
  systemd.network = {
    enable = true;
    networks."50-wan" = {
      address = [
        "192.168.1.135/24"
      ];
      dns = [
        "192.168.1.1"
        "10.0.0.1"
      ];
      gateway = ["192.168.1.1"];

      matchConfig.Name = "enp4*";
      linkConfig.RequiredForOnline = "routable";
    };
  };
  networking.useNetworkd = true;
}
