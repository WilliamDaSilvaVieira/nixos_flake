{ inputs, pkgs, ... }:
{
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
      vscode

      # Tools
      lazygit
      tokei

      #### Proprietary
      (discord.override {
        # withOpenASAR = true;
        withVencord = true;
      })
      spotify-adblock

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

      appimage-run

      #NTFS
      fuse
      ntfs3g
    ];
  };
}
