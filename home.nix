{ pkgs, ... }:
{
  home.stateVersion = "24.05";

  services.mpris-proxy.enable = true;

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
      package = pkgs.tela-circle-icon-theme;
      name = "Tela-circle";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "Graphite-Dark";
  };

  home.pointerCursor = {
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 32;
    gtk.enable = true;
  };
}
