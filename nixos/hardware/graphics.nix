{ pkgs, ... }:
{
  # Opengl(?)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ nvidia-vaapi-driver ];
  };
}
