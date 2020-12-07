{ stdenv, fetchurl, undmg, maintainers, config }:

stdenv.mkDerivation {
  pname = "basecamp";
  version = "2.2.0";

  src = fetchurl {
    url = "https://bc3-desktop.s3.amazonaws.com/mac/basecamp3.dmg";
    sha256 = "10cnhw21hykyazndfdvmdivb2i2vw16i89mz2jg15bkdylx7r9pk";
  };

  buildInputs = [ undmg ];

  sourceRoot = "Basecamp 3.app";

  installPhase = ''
      mkdir -p "$out/Applications/Basecamp 3.app"
      cp -Rp . "$out/Applications/Basecamp 3.app"
  '';

  meta = {
    description = "The All-In-One Toolkit for Working Remotely. (Basecamp 3)";
    homepage = https://basecamp.com/;
    platforms = stdenv.lib.platforms.darwin;
    maintainers = [ maintainers.jeffh ];
  };
}
