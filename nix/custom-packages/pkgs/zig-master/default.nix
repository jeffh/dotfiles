{ stdenv, fetchurl, openjdk, rlwrap, makeWrapper, maintainers }:

let
  host = stdenv.hostPlatform;
  platform = if host.isDarwin then "macos"
             else if host.isBSD then "freebsd"
             else if host.isLinux then "linux"
             else throw "unsupported platform";

  platformSha256 = if host.isDarwin then "b2a4c560f7daf42f9575546cd80dc72d88167edd310286b15922df776bbc0357"
                   else if host.isBSD then "63c8ef22e2b82b33d9848e969f684fb95111cd1f8307f761de81542397e2161f"
                   else if host.isLinux then (
                     if host.isx86_64 then "28985c886ee9b11bdf30ec18a042ae06e302bef50b8cc37664cce419cd3d97c7"
                     else if stdenv.hostPlatform.isAarch64 then "28985c886ee9b11bdf30ec18a042ae06e302bef50b8cc37664cce419cd3d97c7"
                     else throw "unsupported architecture on linux"
                   ) else throw "unsupported platform";

in
stdenv.mkDerivation rec {
    pname = "zig-master";
    version = "0.6.0+b28992de7";

    src = fetchurl {
      url = "https://ziglang.org/builds/zig-${platform}-${stdenv.hostPlatform.qemuArch}-${version}.tar.xz";
      sha256 = "${platformSha256}";
    };

    buildInputs = [ makeWrapper ];

    installPhase = let
        binPath = stdenv.lib.makeBinPath [ rlwrap ];
    in
      ''
        mkdir -p $prefix/lib

        cp -r lib/zig $prefix/lib

        install -Dt $out/bin zig
        wrapProgram $out/bin/zig --prefix PATH : $out/bin:${binPath}
    '';


    meta = {
        description = "The Zig Programming Language (version ${version})";
        homepage = https://ziglang.org/;
        license = stdenv.lib.licenses.mit;
        platforms = stdenv.lib.platforms.unix;
        maintainers = [ maintainers.jeffh ];
    };
}

