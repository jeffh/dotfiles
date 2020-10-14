{ stdenv, fetchurl, undmg, maintainers, config }:

stdenv.mkDerivation {
  pname = "hey-email";
  version = "1.0.11";

  src = fetchurl {
    url = "https://hey-desktop.s3.amazonaws.com/HEY.dmg";
    sha256 = "0p2qdj7n3f1ld56cgjf7nsb13j66825ngdx36910w5lxss1g5vw7";
  };

  buildInputs = [ undmg ];

  sourceRoot = "HEY.app";

  installPhase = ''
      mkdir -p "$out/Applications/HEY.app"
      cp -Rp . "$out/Applications/HEY.app"
  '';

  meta = {
    description = "Email’s new heyday";
    homepage = https://hey.com/;
    platforms = stdenv.lib.platforms.darwin;
    maintainers = [ maintainers.jeffh ];
  };
}
