{ system ? builtins.currentSystem }:

let
    nixpkgs = import <nixpkgs> { inherit system; };
    allPkgs = nixpkgs // pkgs;
    callPackage = path: overrides:
        let f = import path;
        in f ((builtins.intersectAttrs (builtins.functionArgs f) allPkgs) // overrides);
    pkgs = with nixpkgs; {
        openjdk12 = callPackage ./pkgs/openjdk { };
        clojure = callPackage ./pkgs/clojure { };
    };
in pkgs
