{ ... }: {
  networking.nat.enable = true;
  networking.nat.externalInterface = "enp4s0f0";
  networking.nat.internalInterfaces = [ "wg0" ];
}
