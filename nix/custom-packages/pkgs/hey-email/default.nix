{ stdenv, fetchurl, undmg, maintainers, config, pkgs }:

stdenv.mkDerivation rec {
  pname = "hey-email";
  version = "1.2.0";

  src = fetchurl {
    name = "HEY-${version}.dmg";
    url = "https://hey-desktop.s3.amazonaws.com/HEY.dmg?version=${version}";
    sha256 = "0khg8x2dszjpjsps1y98p2dmlfs2sjqak2yarnc8175i478pyl3f";
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
