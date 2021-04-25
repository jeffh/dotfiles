{ stdenv, fetchurl, openjdk, rlwrap, makeWrapper, maintainers, pkgs }:

stdenv.mkDerivation rec {
    pname = "clojure";
    version = "1.10.3.822";

    src = fetchurl {
        url = "https://download.clojure.org/install/clojure-tools-${version}.tar.gz";
        sha256 = "ab45779e8875e076b2d34953eef294935212f9cb8310a4a15630b2c53c157493";
    };

    buildInputs = [ openjdk rlwrap makeWrapper ];

    installPhase = let
        binPath = pkgs.lib.makeBinPath [ rlwrap openjdk ];
    in
      ''
        mkdir -p $prefix/libexec

        cp clojure-tools-${version}.jar $prefix/libexec
        cp {,example-}deps.edn $prefix

        substituteInPlace clojure --replace PREFIX $prefix

        install -Dt $out/bin clj clojure
        wrapProgram $out/bin/clj --prefix PATH : $out/bin:${binPath}
        wrapProgram $out/bin/clojure --prefix PATH : $out/bin:${binPath}
    '';

    installCheckPhase = ''
      CLJ_CONFIG=$out CLJ_CACHE=$out/libexec $out/bin/clojure \
        -Spath \
        -Sverbose \
        -Scp $out/libexec/clojure-tools-${version}.jar
    '';


    meta = {
        description = "The Clojure Programming Language (version ${version})";
        homepage = https://clojure.org;
        license = pkgs.lib.licenses.epl10;
        platforms = pkgs.lib.platforms.unix;
        maintainers = [ maintainers.jeffh ];
    };
}

