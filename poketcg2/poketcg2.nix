{
  pkgs ? import <nixpkgs> {},
  rgbds ? pkgs.callPackage ../rgbds/rgbds.nix {inherit pkgs;},
}: let

  src_rev = "9c82f1dea733dab4d71a92d3c4409a06c478238b";

  src = pkgs.fetchFromGitHub {
    owner = "pret";
    repo = "poketcg2";
    rev = src_rev;
    hash = "sha256-lV7NsqyAHDExFM8gDSqFiZBBdqCggS566Bqc3ECUqBI=";
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

  poketcg2 = pkgs.stdenv.mkDerivation (common // {
    pname = "poketcg2";
    buildPhase = "make poketcg2.gbc";
  });

in
  {
    derivations = {
      inherit poketcg2;
    };
  }
