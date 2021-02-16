{ stdenv, fetchurl, llvmPackages, libiconv, makeWrapper, maintainers, pkgs }:
stdenv.mkDerivation rec {
  pname = "odin";
  version = "0.13.0";

  src = fetchurl {
    url = "https://github.com/odin-lang/Odin/archive/v${version}.tar.gz";
    sha256 = "1w6dahfk4npqw1ii1rsvyrq84ajbzfa1sw5w3bskgpwgpgfc925f";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    llvmPackages.clang-unwrapped
    llvmPackages.bintools
  ] ++ pkgs.lib.optionals stdenv.isDarwin [ libiconv ];

  buildPhase = ''
      make release
    '';

    installPhase = let
      binPath = pkgs.lib.makeBinPath [ llvmPackages.bintools ];
    in ''
      mkdir -p "$out/bin"
      cp -r core "$out"

      install -Dt $out/bin odin
      wrapProgram $out/bin/odin --prefix PATH : $out/bin:${binPath}
  '';

  meta = {
    description = "The Odin Programming Language (version ${version})";
    homepage = https://odin-lang.org/;
    license = pkgs.lib.licenses.mit;
    platforms = pkgs.lib.platforms.unix;
    maintainers = [ maintainers.jeffh ];
  };
}
