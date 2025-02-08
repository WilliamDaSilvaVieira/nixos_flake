{ pkgs, ... }:
{
    gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 32;
    };
    theme = {
      package = pkgs.graphite-gtk-theme;
      name = "Graphite-Dark";
    };
    iconTheme = {
      package = pkgs.stable.tela-circle-icon-theme;
      name = "Tela-circle";
    };
  };
}
