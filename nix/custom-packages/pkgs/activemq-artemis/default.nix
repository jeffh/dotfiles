{ stdenv, fetchurl, openjdk, libaio, makeWrapper, maintainers }:

stdenv.mkDerivation rec {
  pname = "activemq-artemis";
  version = "2.15.0";

  src = fetchurl {
    name = "apache-artemis-${version}.tar.gz";
    url = "https://www.apache.org/dyn/closer.cgi?filename=activemq/activemq-artemis/${version}/apache-artemis-${version}-bin.tar.gz\&action=download";
    sha512 = "554da0a6b824c6d1970284887a570cd6b8b1b3229f34380f5446b3c9424219a54ffffedef3af682576901d50b10aafc3ee5c672af0750ed77fa3ace61f382927";
  };

  buildInputs = [ openjdk makeWrapper ] ++ (if stdenv.targetPlatform.isLinux then [ libaio ] else []);

  installPhase = let 
    binPath = stdenv.lib.makeBinPath [ openjdk makeWrapper ];
  in ''
    mkdir -p $prefix/bin
    mkdir -p $prefix/lib
    mkdir -p $prefix/schema
    mkdir -p $prefix/web

    cp -r lib/* $prefix/lib/
    cp -r schema/* $prefix/schema/
    cp -r web/* $prefix/web/

    install -Dt $out/bin bin/artemis
    wrapProgram $out/bin/artemis --prefix PATH : $out/bin:${binPath}

    cp -r bin/lib $out/bin/
  '';

  installCheckPhase = ''
    $out/bin/artemis help
  '';

  meta = {
    description = "ActiveMQ Artemis (version ${version})";
    homepage = https://activemq.apache.org/components/artemis/;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix; # TODO: test linux?
    maintainers = [ maintainers.jeffh ];
  };
}
