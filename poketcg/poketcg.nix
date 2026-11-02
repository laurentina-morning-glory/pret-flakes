{
  pkgs ? import <nixpkgs> {},
  rgbds ? pkgs.callPackage ../rgbds/rgbds.nix {inherit pkgs;},
}: let

  src_rev = "3054a4465938cfd744bab6f976c090884561d433";

  src = pkgs.fetchFromGitHub {
    owner = "pret";
    repo = "poketcg";
    rev = src_rev;
    hash = "sha256-glzSy0w32NtB0xmP5ohcDzRDFENXtY/r0XKbeBeGzCk=";
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

  poketcg = pkgs.stdenv.mkDerivation (common // {
    pname = "poketcg";
    buildPhase = "make poketcg.gbc";
  });

in
  {
    derivations = {
      inherit poketcg;
    };
  }
