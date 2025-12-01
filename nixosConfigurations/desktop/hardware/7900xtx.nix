{pkgs, ...}: {
  boot.kernelModules = ["amdgpu"];
  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
    amdgpu_top
  ];
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
  };
}
