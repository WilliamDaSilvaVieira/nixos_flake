{ ... }:
{
  # Xdg
  xdg = {
    portal = {
      config.common.default = "*";
      enable = true;
      wlr.enable = true;
    };
    icons.enable = true;
    mime = {
      enable = true;
      defaultApplications = {
        "text/*" = "Helix.desktop";
        "text/plain" = "Helix.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
        "application/rdf+xml" = "org.pwmt.zathura.desktop";
        "application/rss+xml" = "org.pwmt.zathura.desktop";
        "application/xhtml+xml" = "org.pwmt.zathura.desktop";
        "application/xhtml_xml" = "org.pwmt.zathura.desktop";
        "application/xml" = "org.pwmt.zathura.desktop";
        "image/*" = "imv.desktop";
        "image/png" = "imv.desktop";
        "image/jpeg" = "imv.desktop";
        "image/gif" = "imv.desktop";
        "image/webp" = "imv.desktop";
        "video/*" = "mpv.desktop";
        # "text/html" = "librewolf.desktop";
        # "text/xml" = "librewolf.desktop";
        # "x-scheme-handler/http" = "librewolf.desktop";
        # "x-scheme-handler/https" = "librewolf.desktop";
        # "x-scheme-handler/about" = "librewolf.desktop";
        # "x-scheme-handler/unknown" = "librewolf.desktop";
        # "x-scheme-handler/mailto" = "librewolf.desktop";
        # "x-scheme-handler/webcal" = "librewolf.desktop";
      };
    };
  };
}
