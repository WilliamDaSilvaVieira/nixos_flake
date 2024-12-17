{ pkgs, ... }:
{
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
}
