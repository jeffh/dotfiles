{ stdenv, fetchurl, llvmPackages, libiconv, maintainers }:
stdenv.mkDerivation rec {
  pname = "odin";
  version = "0.13.0";

  src = fetchurl {
    url = "https://github.com/odin-lang/Odin/archive/v${version}.tar.gz";
    sha256 = "1w6dahfk4npqw1ii1rsvyrq84ajbzfa1sw5w3bskgpwgpgfc925f";
  };

  buildInputs = [
    llvmPackages.clang-unwrapped
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv ];

  buildPhase = ''
      make all release
    '';

  installPhase = ''
      mkdir -p "$out/bin"

      cp odin "$out/bin/odin"
      chmod +x "$out/bin/odin"
  '';

  meta = {
    description = "The Odin Programming Language (version ${version})";
    homepage = https://odin-lang.org/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ maintainers.jeffh ];
  };
}
