{ ... }:
{
  imports = [
    ../../gtk.nix
    ../../pointerCursor.nix
    ../../qt.nix
  ];
  services.mpris-proxy.enable = true;

  home.stateVersion = "25.05";
}
