{ stdenv, fetchurl, darwin, openjdk12, rlwrap, makeWrapper
}:

stdenv.mkDerivation rec {
    version = "1.10.1.447";
    name = "clojure-${version}";

    installPhase = let
        binPath = stdenv.lib.makeBinPath [ rlwrap openjdk12 ];
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

    buildInputs = [ openjdk12 rlwrap makeWrapper ];

    src = fetchurl {
        url = https://download.clojure.org/install/clojure-tools-1.10.1.447.tar.gz;
        sha256 = "0ca99763309d92ed7216dbbb29d448e4056305419f0560737d8c893a1f3d1040";
    };

    meta = {
        description = "The Clojure Programming Language (version ${version})";
        homepage = "https://clojure.org";
        license = stdenv.lib.licenses.epl10;
        platforms = stdenv.lib.platforms.darwin;
    };
}

