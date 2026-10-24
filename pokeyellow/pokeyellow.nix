{
  pkgs ? import <nixpkgs> {},
  rgbds ? pkgs.callPackage ../rgbds/rgbds.nix {inherit pkgs;},
}: let

  src_rev = "9327549dce06435ec3fd0334057bd32b0ba29876";

  src = pkgs.fetchFromGitHub {
    owner = "pret";
    repo = "pokeyellow";
    rev = src_rev;
    hash = "sha256-UKqcPtAxSlF7FGhEEGev5t2jIQgFx82xz4OK/QwXnRw=";
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

  pokeyellow = pkgs.stdenv.mkDerivation (common // {
    pname = "pokeyellow";
    buildPhase = "make pokeyellow.gbc";
  });

  pokeyellow-debug = pkgs.stdenv.mkDerivation (common // {
    pname = "pokeyellow-debug";
    buildPhase = "make pokeyellow_debug.gbc";
  });

in
  {inherit pokeyellow pokeyellow-debug;}

