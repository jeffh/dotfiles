{ stdenv, fetchurl, undmg, maintainers, config, pkgs }:

stdenv.mkDerivation rec {
  pname = "hey-email";
  version = "1.1.0";

  src = fetchurl {
    name = "HEY-${version}.dmg";
    url = "https://hey-desktop.s3.amazonaws.com/HEY.dmg?version=${version}";
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
    platforms = pkgs.lib.platforms.darwin;
    maintainers = [ maintainers.jeffh ];
  };
}
