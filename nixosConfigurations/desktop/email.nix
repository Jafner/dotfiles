{
  pkgs,
  username,
  ...
}: {
  home-manager.users."${username}" = {
    home.packages = with pkgs; [
      protonmail-desktop
      protonmail-bridge-gui
      thunderbird
    ];
  };
}
