{
  pkgs ? (import ./nixpkgs.nix) { },
}:
{
  default = pkgs.mkShell {
    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git
    ];
  };
  ryujinx = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      libxkbcommon
      libGL
      icu
      icu.dev
    ];
    shellHook = ''
      LD_LIBRARY_PATH="''${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}${
        with pkgs;
        lib.makeLibraryPath [
          icu
          icu.dev
          vulkan-loader
          xorg.libX11
          xorg.libXcursor
          xorg.libXi
          xorg.libXrandr
        ]
      }"
      export LD_LIBRARY_PATH
    '';
    LD_LIBRARY_PATH = "${pkgs.icu}/lib:${pkgs.icu.dev}/lib:${pkgs.libxkbcommon}/lib:${pkgs.libGL}/lib";
  };
}

