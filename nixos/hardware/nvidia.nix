{ config, ... }:
{
  hardware.nvidia = {
    powerManagement = {
      enable = true;
      finegrained = false;
    };
    forceFullCompositionPipeline = true;
    nvidiaSettings = true;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    open = true;
  };
}
