{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    xkb.layout = "br";
    excludePackages = with pkgs; [ xterm ];
    videoDrivers = [ "nvidia" ];
    displayManager.startx.enable = true;
    windowManager.awesome.enable = true;
  };
}
