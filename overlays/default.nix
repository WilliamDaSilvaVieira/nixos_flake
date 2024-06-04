# This file defines overlays
{ inputs, ... }:
{
  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  nixpkgs-23_11-packages = final: _prev: {
    nixpkgs-23_11 = import inputs.nixpkgs-23_11 {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
