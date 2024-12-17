{ pkgs, ... }:
{
  # Boot.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "amd_iommu=on"
      "iommu=pt"
    ];
    kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
      "vfio-pci"
    ];
    # blacklistedKernelModules = [ "kms" ];
    loader = {
      systemd-boot.enable = true;
      timeout = 0;
    };
  };
}
