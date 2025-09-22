{
  pkgs,
  username,
  ...
}: {
  home-manager.users."${username}" = {
    programs.bat = {
      enable = true;
    };
    programs.btop = {
      enable = true;
      package = pkgs.btop-rocm;
      settings = {
        color_theme = "stylix";
        theme_background = true;
        update_ms = 500;
      };
    };
    programs.eza = {
      enable = true;
    };
    programs.lsd = {
      enable = true;
    };
    programs.fd = {
      enable = true;
    };
    programs.fzf = {
      enable = true;
    };
    programs.jq = {
      enable = true;
    };
    programs.zoxide = {
      enable = true;
    };
    programs.lazygit = {
      enable = true;
    };
  };
}
