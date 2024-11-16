# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # <home-manager/nixos>
  ];

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

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";
  time.hardwareClockInLocalTime = true;

  networking = {
    hostName = "william";
    networkmanager.enable = true;

    firewall = {
      allowedTCPPorts = [
        5900
      ];
      allowedUDPPorts = [
        5900
      ];
    };
  };

  # Fonts
  fonts = {
    packages = with pkgs; [
      nerdfonts
      noto-fonts
      noto-fonts-emoji
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      google-fonts
      terminus_font
      corefonts
      vistafonts
    ];
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "pt_BR.UTF-8"; # Erros, Warnings, Etc ...
    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEFONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
  };

  console = {
    font = "Terminus";
    packages = with pkgs; [
      terminus_font
    ];
    keyMap = "br-abnt2";
    colors = [
      # Use terminal.sexy with alacritty
      # Material
      "192024"
      "ed2e30"
      "099923"
      "0ca9c6"
      "218354"
      "e91e63"
      "e2bf06"
      "cfd8dc"
      "3f5b69"
      "ef4848"
      "045d9e"
      "25a958"
      "81d4fa"
      "ad1457"
      "701b78"
      "eceff1"
    ];
  };

  # Services
  services = {
    pipewire = {
      enable = true;
      audio = {
        enable = true;
      };
      wireplumber = {
        enable = true;
      };
      pulse = {
        enable = true;
      };
      jack = {
        enable = true;
      };
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;
    };
    devmon = {
      enable = true;
    };
    # greetd = {
    #   enable = false;
    #   settings = {
    #     default_session = {
    #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --user-menu -t -c Hyprland";
    #     };
    #   };
    # };
    openssh = {
      enable = true;
      settings = {
        # Forbid root login through SSH.
        PermitRootLogin = "no";
        # Use keys only. Remove if you want to SSH using password (not recomended)
        PasswordAuthentication = true;
      };
    };
    picom = {
      enable = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [ epson-escpr ];
      browsing = true;
      defaultShared = true;
    };
    udisks2 = {
      enable = true;
    };
    xserver = {
      enable = true;
      xkb.layout = "br";
      excludePackages = with pkgs; [ xterm ];
      videoDrivers = [ "nvidia" ];
      displayManager.startx.enable = true;
      windowManager.awesome.enable = true;
    };
    spice-vdagentd.enable = true;
    # desktopManager.cosmic.enable = true;
    # displayManager.cosmic-greeter.enable = true;
  };

  # Hardware
  hardware = {
    # Bluetooth
    bluetooth = {
      enable = true;
    };

    # Nvidia
    nvidia = {
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      forceFullCompositionPipeline = true;
      nvidiaSettings = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      open = true;
    };

    # Opengl(?)
    graphics = {
      enable = true;
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
    };

    # PulseAudio
    pulseaudio = {
      enable = false;
    };

    # Steam
    steam-hardware.enable = true;

    enableAllFirmware = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.fish;
    users = {
      william = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "libvirtd"
        ];
      };
    };
  };

  # Virtualisation
  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
        runAsRoot = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
  systemd.services.libvirtd = {
    path =
      let
        env = pkgs.buildEnv {
          name = "qemu-hook-env";
          paths = with pkgs; [
            bash
            libvirt
            kmod
            systemd
            ripgrep
            sd
          ];
        };
      in
      [ env ];

    preStart = ''
      mkdir -p /var/lib/libvirt/hooks
      mkdir -p /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin
      mkdir -p /var/lib/libvirt/hooks/qemu.d/win11/release/end

      ln -sf /etc/libvirt/hooks/qemu /var/lib/libvirt/hooks/qemu
      ln -sf /etc/libvirt/hooks/qemu.d/win11/prepare/begin/start.sh /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/start.sh
      ln -sf /etc/libvirt/hooks/qemu.d/win11/release/end/finish.sh /var/lib/libvirt/hooks/qemu.d/win11/release/end/finish.sh

      chmod +x /var/lib/libvirt/hooks/qemu
      chmod +x /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/start.sh
      chmod +x /var/lib/libvirt/hooks/qemu.d/win11/release/end/finish.sh
    '';
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    defaultPackages = [ ];
    systemPackages = with pkgs; [
      #### Core
      lld
      gcc
      glibc
      clang
      llvmPackages.bintools
      wget
      killall
      zip
      unzip
      exfat
      lm_sensors
      git

      libnotify
      exiftool

      #### Vulkan
      vulkan-tools
      stable.vulkan-validation-layers
      vulkan-loader
      vulkan-headers

      #### Linux
      linuxHeaders
      linux-firmware

      #### Party Tricks
      cmatrix
      cowsay
      sl
      lolcat
      figlet

      # Nix
      nil
      nixfmt-rfc-style

      #### Browser
      (google-chrome.override {
        commandLineArgs = [
          "--force-device-scale-factor=1.333333"
          "--enable-blink-features=MiddleClickAutoscroll"
        ];
      })
      inputs.zen-browser.packages."${system}".specific
      tor-browser

      tor

      #### Media
      yt-dlp
      stable.cava
      pavucontrol
      zathura
      yazi
      ffmpeg
      ffmpegthumbnailer
      mpv
      transmission_4-gtk

      #Virtualization
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio
      win-spice

      #### Programing
      ### Languages
      # Rust
      rustup
      # Python
      python3

      # Dependencies
      rocmPackages.llvm.lldb

      # Markdown
      marksman
      slides
      graph-easy
      glow

      # Bash
      stable.nodePackages.bash-language-server

      # Editors
      helix

      # Tools
      lazygit
      tokei

      #### Proprietary
      (discord.override {
        withOpenASAR = true;
        # withVencord = true;
      })

      starship
      feh
      bat
      p7zip
      freshfetch
      neofetch
      trash-cli
      fzf
      fd
      ripgrep
      btop
      eza
      kitty
      speedtest-cli
      libreoffice

      # Hyprland
      wlr-randr
      rofi-wayland
      swaybg
      mpvpaper
      imv
      dunst
      grim
      slurp
      wl-clipboard
      stable.wf-recorder
      wlroots

      ani-cli
      stable.mangal
      mangohud
      nixpkgs-23_11.yuzu-mainline
      ryujinx
      fceux
      zsnes2
      stable.cemu
      stable.rpcs3
      tradingview

      #NTFS
      fuse
      ntfs3g
    ];
  };

  # Programs
  programs = {
    dconf = {
      enable = true;
    };
    fish = {
      enable = true;
    };
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
    xwayland = {
      enable = true;
    };
    hyprland = {
      enable = true;
      # package = pkgs.nixpkgs-23_11.hyprland;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland = {
        enable = true;
      };
    };
    waybar = {
      enable = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    localsend = {
      enable = true;
      openFirewall = true;
    };
  };

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

  # Security
  security = {
    sudo.enable = false;
    rtkit.enable = true;
    doas = {
      enable = true;
      extraRules = [
        {
          groups = [ "wheel" ];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };

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

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      outputs.overlays.stable-packages
      outputs.overlays.nixpkgs-23_11-packages
      (final: prev: {
        awesome = inputs.nixpkgs-f2k.packages.${final.system}.awesome-luajit-git;
        discord = prev.discord.overrideAttrs (_: {
          src = builtins.fetchTarball {
            url = "https://discord.com/api/download?platform=linux&format=tar.gz";
            sha256 = "0qzdvyyialvpiwi9mppbqvf2rvz1ps25mmygqqck0z9i2q01c1zd";
          };
        });
      })
    ];
  };

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      download-buffer-size = 268435456; # Define o buffer para 256MB
      binary-caches = [ "https://cache.nixos.org" ];
      narinfo-cache-positive-ttl = 86400; # 1 dia para pacotes existentes
      narinfo-cache-negative-ttl = 3600; # 1 hora para pacotes inexistentes
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
