{
  username,
  pkgs,
  ...
}: {
  services.xserver.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.displayManager.ly.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.xwayland.enable = true;
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kate
    okular
    discover
    plasma-activities
  ];
  home-manager.users."${username}" = {
    home.packages = with pkgs; [
      kdePackages.kcalc
      kdePackages.filelight
      wl-clipboard
      wl-color-picker
      dotool
    ];
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
    ];
  };
}
