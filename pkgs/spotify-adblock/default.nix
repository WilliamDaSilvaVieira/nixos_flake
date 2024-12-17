# Code adapted from https://github.com/NL-TCH/nur-packages
{
  lib,
  rustPlatform,
  fetchFromGitHub,
  spotify,
  zip,
  unzip,
}:

let
  spotify-adblock = rustPlatform.buildRustPackage rec {
    pname = "spotify-adblock";
    version = "1.0.3";

    src = fetchFromGitHub {
      owner = "abba23";
      repo = "spotify-adblock";
      rev = "v${version}";
      hash = "sha256-UzpHAHpQx2MlmBNKm2turjeVmgp5zXKWm3nZbEo0mYE=";
    };

    cargoHash = "sha256-wPV+ZY34OMbBrjmhvwjljbwmcUiPdWNHFU3ac7aVbIQ=";

    patchPhase = ''
      substituteInPlace src/lib.rs \
        --replace 'config.toml' $out/etc/spotify-adblock/config.toml
    '';

    buildPhase = ''
      make
    '';

    installPhase = ''
      mkdir -p $out/etc/spotify-adblock
      install -D --mode=644 config.toml $out/etc/spotify-adblock
      mkdir -p $out/lib
      install -D --mode=644 --strip target/release/libspotifyadblock.so $out/lib
    '';

    meta = {
      description = "Adblocker for Spotify";
      homepage = "https://github.com/abba23/spotify-adblock";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ ];
      mainProgram = "spotify-adblock";
      conflicts = [ spotify ];
    };
  };
in
spotify.overrideAttrs (oldAttrs: {
  postInstall =
    (oldAttrs.postInstall or "")
    + ''
      ln -s ${spotify-adblock}/lib/libspotifyadblock.so $libdir
      sed -i "s:^Name=Spotify.*:Name=Spotify-adblock:" "$out/share/spotify/spotify.desktop"
      wrapProgram $out/bin/spotify \
        --set LD_PRELOAD "${spotify-adblock}/lib/libspotifyadblock.so"

      # Hide placeholder for advert banner
      ${unzip}/bin/unzip -p $out/share/spotify/Apps/xpui.spa xpui.js | sed 's/adsEnabled:\!0/adsEnabled:false/' > $out/share/spotify/Apps/xpui.js
      ${zip}/bin/zip --junk-paths --update $out/share/spotify/Apps/xpui.spa $out/share/spotify/Apps/xpui.js
      rm $out/share/spotify/Apps/xpui.js
    '';
})
