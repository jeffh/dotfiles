{ stdenv, fetchzip, maintainers, config }:

let
  cfg = config.applications.apptivate;
in
  stdenv.mkDerivation {
    pname = "apptivate";
    version = "2.2";

    src = fetchzip {
      url = "http://www.apptivateapp.com/resources/Apptivate.app.zip";
      sha256 = "0w3rp4cchbnmcdal8bcirvwrk5wr1w9gb6h6blbhij8zga9c3hh4";
      stripRoot = false;
    };

    installPhase = ''
      mkdir -p "$out/Applications/Apptivate.app"
      cp -Rp Apptivate.app "$out/Applications/Apptivate.app"
    '';

    meta = {
      description = "A simple, beautiful way to create global hotkeys for your files and applications.";
      homepage = http://www.apptivateapp.com;
      platforms = stdenv.lib.platforms.darwin;
      maintainers = [ maintainers.jeffh ];
    };
  }
