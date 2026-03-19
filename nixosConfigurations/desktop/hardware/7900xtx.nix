{
  pkgs,
  username,
  ...
}: {
  boot.kernelModules = ["amdgpu"];
  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
    amdgpu_top
  ];
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
  };
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };
  home-manager.users.${username} = {
    targets.genericLinux.nixGL = {
      vulkan.enable = true;
      defaultWrapper = "mesa";
      installScripts = ["mesa"];
    };
  };
}
