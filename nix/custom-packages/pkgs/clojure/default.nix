{ stdenv, fetchurl, darwin, openjdk, rlwrap, makeWrapper, maintainers }:

stdenv.mkDerivation rec {
    pname = "clojure";
    version = "1.10.1.697";

    src = fetchurl {
        url = "https://download.clojure.org/install/clojure-tools-${version}.tar.gz";
        sha256 = "0x2r6qzn49gj4h9w1xkv3prs7c5lpck617zxj8rxlpnrzajd83bh";
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

