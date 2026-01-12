{
  pkgs,
  username,
  ...
}: {
  #programs.xwayland.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true; 
}
