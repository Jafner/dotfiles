{
  inputs,
  system,
  ...
}: {
  programs.nh = {
    enable = true;
    flake = "/home/joey/Git/dotfiles";
  };
  nixpkgs = {
    hostPlatform = system;
    overlays = [
      inputs.nixgl.overlay
      inputs.chaotic.overlays.default
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      nvidia.acceptLicense = true;
    };
  };
  nix.settings = {
    download-buffer-size = 1073741824;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
    auto-optimise-store = true;
  };
  nix.extraOptions = ''
    accept-flake-config = true
    warn-dirty = false
  '';
}
