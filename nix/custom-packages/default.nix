{ system ? builtins.currentSystem }:

let
    nixpkgs = import <nixpkgs> { inherit system; };
    allPkgs = nixpkgs // pkgs;
    # maintainers = nixpkgs.lib.mkMerge(nixpkgs.stdenv.lib.maintainers (import ./maintainers));
    maintainers = nixpkgs.lib.maintainers // (import ./maintainers);

    callPackage = path: overrides:
        let f = import path;
        in f ((builtins.intersectAttrs (builtins.functionArgs f) allPkgs) // { maintainers = maintainers; } // overrides);

    pkgs = with nixpkgs; {
      apptivate = callPackage ./pkgs/apptivate { };
      hey-email = callPackage ./pkgs/hey-email { };
      basecamp = callPackage ./pkgs/basecamp { };
      clojure = callPackage ./pkgs/clojure { };
      activemq-artemis = callPackage ./pkgs/activemq-artemis { };
      zig-master = callPackage ./pkgs/zig-master { };
      doctl = nixpkgs.callPackage ./pkgs/doctl { };
      odin = callPackage ./pkgs/odin { };
      virtualfish = callPackage ./pkgs/virtualfish { };
    };
in pkgs
