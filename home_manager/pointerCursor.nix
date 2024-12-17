{ pkgs, ... }:
{
    home.pointerCursor = {
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 32;
    gtk.enable = true;
  };
}
