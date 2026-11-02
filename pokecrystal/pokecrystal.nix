{
  pkgs ? import <nixpkgs> {},
  rgbds ? pkgs.callPackage ../rgbds/rgbds.nix {inherit pkgs;},
}: let

  src_rev = "619f3703486b3b40f69d31b1911b58aa0a721a6e";

  src = pkgs.fetchFromGitHub {
    owner = "pret";
    repo = "pokecrystal";
    rev = src_rev;
    hash = "sha256-Q0sqXerROV9xbTV/4z6OxtGF8mswBojwpOGJExbo96A=";
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

  pokecrystal = pkgs.stdenv.mkDerivation (common // {
    pname = "pokecrystal";
    buildPhase = "make pokecrystal.gbc";
  });

  pokecrystal11 = pkgs.stdenv.mkDerivation (common // {
    pname = "pokecrystal11";
    buildPhase = "make pokecrystal11.gbc";
  });

  pokecrystal-au = pkgs.stdenv.mkDerivation (common // {
    pname = "pokecrystal-au";
    buildPhase = "make pokecrystal_au.gbc";
  });

  pokecrystal-debug = pkgs.stdenv.mkDerivation (common // {
    pname = "pokecrystal-debug";
    buildPhase = "make pokecrystal_debug.gbc";
  });

  pokecrystal11-debug = pkgs.stdenv.mkDerivation (common // {
    pname = "pokecrystal11-debug";
    buildPhase = "make pokecrystal11_debug.gbc";
  });

in
  {
    derivations = {
      inherit pokecrystal pokecrystal11 pokecrystal-au pokecrystal-debug pokecrystal11-debug;
    };
  }
