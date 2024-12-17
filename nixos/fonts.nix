{ pkgs, ... }:
{
  # Fonts
  fonts = {
    packages = with pkgs; [
      stable.nerdfonts
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
}
