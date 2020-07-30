{ stdenv, fetchurl, darwin, openjdk, rlwrap, makeWrapper, maintainers }:

stdenv.mkDerivation rec {
    pname = "clojure";
    version = "1.10.1.536";

    src = fetchurl {
        url = "https://download.clojure.org/install/clojure-tools-${version}.tar.gz";
        sha256 = "b7c5b0cdeb750275ddd98095a1959657b95569b624da7c6163adce5a7d5f7119";
    };

    buildInputs = [ openjdk rlwrap makeWrapper ];

    installPhase = let
        binPath = stdenv.lib.makeBinPath [ rlwrap openjdk ];
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
        license = stdenv.lib.licenses.epl10;
        platforms = stdenv.lib.platforms.unix;
        maintainers = [ maintainers.jeffh ];
    };
}

