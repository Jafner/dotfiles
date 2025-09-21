{
  pkgs,
  config,
  ...
}: {
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
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.xone.enable = true;
  hardware.steam-hardware.enable = true;
  boot.kernelModules = ["amdgpu"];
  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
    amdgpu_top
    linuxKernel.packages.linux_6_16.xone
  ];
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
  };
}
