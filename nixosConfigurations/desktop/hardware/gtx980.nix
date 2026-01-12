{
  config,
  lib,
  ...
}: {
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
  };
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
  environment.variables = {
    #GBM_BACKEND = "nvidia-drm";
    #NIXOS_OZONE_WL = "1";
    #NVD_BACKEND = "direct";
    #LIBVA_DRIVER_NAME = "nvidia";
    #WLR_NO_HARDWARE_CURSORS = "1";
    #__GLX_VENDOR_LIBRARY_NAME = "nvidia";
    #KWIN_DRM_DEVICES = "/dev/dri/renderD128";
  };
}
