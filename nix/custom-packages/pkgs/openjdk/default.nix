{ stdenv, fetchurl, darwin
}:

stdenv.mkDerivation rec {
    version = "12.0.1";
    name = "openjdk-${version}";

    buildPhase = ''
        tar xzf $src
        '';

    installPhase = ''
        mkdir $out
        mv jdk-12.0.1.jdk/Contents/Home/bin $out/bin
        mv jdk-12.0.1.jdk/Contents/Home/conf $out/conf
        mv jdk-12.0.1.jdk/Contents/Home/include $out/include
        mv jdk-12.0.1.jdk/Contents/Home/jmods $out/jmods
        mv jdk-12.0.1.jdk/Contents/Home/legal $out/legal
        mv jdk-12.0.1.jdk/Contents/Home/lib $out/lib
        mv jdk-12.0.1.jdk/Contents/Home/release $out/release

        mkdir -p $out/nix-support
cat <<EOF > $out/nix-support/setup-hook
if [ -z "\$JAVA_HOME" ]; then export JAVA_HOME=$out; fi
EOF
        '';

    src = fetchurl {
        url = https://download.java.net/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_osx-x64_bin.tar.gz;
        sha256 = "cba6f42f82496f62c51fb544e243d440984d442bdc906550a30428d8be6189e5";
    };

    meta = {
        description = "OpenJDK ${version}";
        homepage = "https://jdk.java.net/12/";
        license = stdenv.lib.licenses.gpl2;
        platforms = stdenv.lib.platforms.darwin;
    };
}
