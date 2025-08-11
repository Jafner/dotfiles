{
  pkgs,
  username,
  ...
}: {
  home-manager.users."${username}" = {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-vaapi
        obs-vkcapture
        wlrobs
      ];
    };
    home.file."theme" = {
      recursive = true;
      source = ./custom-obs-theme/Custom.obt;
      target = ".config/obs-studio/themes/Custom.obt";
    };
  };

  # Required for use of Virtual Camera
  boot.extraModulePackages = [
    pkgs.linuxPackages_cachyos.v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;
}
