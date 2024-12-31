{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = with pkgs.stable; [ epson-escpr ];
    browsing = true;
    defaultShared = true;
  };
}
