# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{
  config,
  inputs,
  outputs,
  lib,
  ...
}:

{
  imports = [
    ./environment
    ./hardware
    ./programs
    ./services
    ./boot.nix
    ./console.nix
    ./fonts.nix
    ./hardware-configuration.nix
    ./i18n.nix
    ./networking.nix
    ../pkgs
    ./security.nix
    ./time.nix
    ./users.nix
    ./virtualisation.nix
    ./xdg.nix
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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
  system.stateVersion = "25.05"; # Did you read the comment?
}
