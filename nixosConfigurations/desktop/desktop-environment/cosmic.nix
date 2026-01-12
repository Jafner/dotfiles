{username, ...}: {
  services.displayManager.cosmic-greeter.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = username;
  };
  services.desktopManager.cosmic.enable = true;
}
