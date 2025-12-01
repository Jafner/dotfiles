{pkgs, ...}: {
  imports = [
    #./7900xtx.nix
    ./gtx980.nix
  ];
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
  ];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  services.printing.enable = false;
  hardware.wooting.enable = true;
  hardware.xpadneo.enable = false;
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.xone.enable = true;
  hardware.steam-hardware.enable = true;
}
