{ ... }:
{
  # Variables
  environment.variables = {
    XCURSOR_SIZE = "32";

    FZF_DEFAULT_COMMAND = "fd -H";

    LIBSEAT_BACKEND = "logind";

    WLR_NO_HARDWARE_CURSORS = "1";
    # WLR_RENDERER = "vulkan";
    WLR_DRM_NO_ATOMIC = "1";

    NIXOS_OZONE_WL = "1";

    GDK_BACKEND = "wayland,x11";

    QT_QPA_PLATFORM = "wayland;xcb";
    QT_SCALE_FACTOR = "1.333333";
    QT_AUTO_SCREEN_SCALE_FACTOR = "0";

    KITTY_ENABLE_WAYLAND = "1";

    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    EDITOR = "hx";
    VISUAL = "hx";
  };
}
