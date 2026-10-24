{
  pkgs ? import <nixpkgs> {},
  rgbds ? pkgs.callPackage ./rgbds.nix {inherit pkgs;},
}: let

  src_rev = "171e2c204f9c1ff8e577ca387a4bbb009e130843";

  src = pkgs.fetchFromGitHub {
    owner = "pret";
    repo = "pokered";
    rev = src_rev;
    hash = "sha256-OGnkd0qm9Rmto7yens2UMicn0YLBXywD7xWD0xcMmB8=";
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

  pokered = pkgs.stdenv.mkDerivation (common // {
    pname = "pokered";
    buildPhase = "make pokered.gbc";
  });

  pokeblue = pkgs.stdenv.mkDerivation (common // {
    pname = "pokeblue";
    buildPhase = "make pokeblue.gbc";
  });

  pokeblue-debug = pkgs.stdenv.mkDerivation (common // {
    pname = "pokeblue-debug";
    buildPhase = "make pokeblue_debug.gbc";
  });

in
  {inherit pokered pokeblue pokeblue-debug;}
