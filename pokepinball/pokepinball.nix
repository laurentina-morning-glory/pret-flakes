{
  pkgs ? import <nixpkgs> {},
  rgbds ? pkgs.callPackage ../rgbds/rgbds.nix {inherit pkgs;},
}: let

  src_rev = "9b67d9afaba83e02d5d238c29868db4142b3037d";

  src = pkgs.fetchFromGitHub {
    owner = "pret";
    repo = "pokepinball";
    rev = src_rev;
    hash = "sha256-fsxiKoTx69X63oXyYuN0dP5559GUjSYqStW30W9lQzA=";
  };

  common = {
    version = src_rev;
    src = src;

    doCheck = true;

    nativeBuildInputs = [
      rgbds
    ];

    checkPhase = ''
      sha1sum --ignore-missing --check rom.sha1
    '';

    installPhase = ''
      mkdir -p "$out"
      mv *.gbc "$out"
    '';

  };

  pokepinball = pkgs.stdenv.mkDerivation (common // {
    pname = "pokepinball";
    buildPhase = "make pokepinball.gbc";
  });

in
  {
    derivations = {
      inherit pokepinball;
    };
  }
