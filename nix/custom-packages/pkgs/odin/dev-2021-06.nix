{ stdenv, fetchzip, fetchurl, llvmPackages, libiconv, makeWrapper, maintainers, pkgs }:
let
  host = stdenv.hostPlatform;
  platform = if host.isDarwin then "ubuntu"
             else if host.isLinux then "ubuntu"
             else throw "unsupported platform";

  platformSha256 = if host.isDarwin then "02kqxnl7whd5rzaqji67gqb2z74k22hr64fy5frbkj17zr53k1jy"
                   else if host.isLinux then (
                     if host.isx86_64 then throw "unsupported architecture on linux"
                     else if stdenv.hostPlatform.isAarch64 then "28985c886ee9b11bdf30ec18a042ae06e302bef50b8cc37664cce419cd3d97c7"
                     else throw "unsupported architecture on linux"
                   ) else throw "unsupported platform";
in
stdenv.mkDerivation rec {
  pname = "odin";
  version = "dev-2021-11";

  src = fetchzip {
    url = "https://github.com/odin-lang/Odin/releases/download/${version}/odin-${platform}-amd64-${version}.zip";
    sha256 = "02kqxnl7whd5rzaqji67gqb2z74k22hr64fy5frbkj17zr53k1jy";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    llvmPackages.clang-unwrapped
    llvmPackages.bintools
  ] ++ pkgs.lib.optionals stdenv.isDarwin [ libiconv ];

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
