{
  pkgs ? import <nixpkgs> {},
  rgbds ? pkgs.callPackage ../rgbds/rgbds.nix {inherit pkgs;},
}: let

  src_rev = "fc702b6d922aecce274782d68bba8639936a1182";

  src = pkgs.fetchFromGitHub {
    owner = "pret";
    repo = "pokegold";
    rev = src_rev;
    hash = "sha256-fx1B+Ere14Pqg//oNPKYjgi9hLZpjvRlFYqLgoRppXs=";
  };

  common = {
    version = src_rev;
    src = src;

    doCheck = true;

    nativeBuildInputs = [
      rgbds
    ];

    checkPhase = ''
      sha1sum --ignore-missing --check roms.sha1
    '';

    installPhase = ''
      mkdir -p "$out"
      mv *.gbc "$out"
    '';

  };

  pokegold = pkgs.stdenv.mkDerivation (common // {
    pname = "pokegold";
    buildPhase = "make pokegold.gbc";
  });

  pokesilver = pkgs.stdenv.mkDerivation (common // {
    pname = "pokesilver";
    buildPhase = "make pokesilver.gbc";
  });

  pokegold-debug = pkgs.stdenv.mkDerivation (common // {
    pname = "pokegold";
    buildPhase = "make pokegold_debug.gbc";
  });

  pokesilver-debug = pkgs.stdenv.mkDerivation (common // {
    pname = "pokesilver";
    buildPhase = "make pokesilver_debug.gbc";
  });

in
  {inherit pokegold pokesilver pokegold-debug pokesilver-debug;}

