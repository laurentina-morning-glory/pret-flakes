{
  pkgs ? import <nixpkgs> {},
}: let

  src = pkgs.fetchFromGitHub {
    owner = "gbdev";
    repo = "rgbds";
    tag = "v1.0.4";
    hash = "sha256-NNw0ZsUEpbmTGq8GZqAszi3Im1Pj331xNSYa7Aq2wWM=";
  };

  rgbds = pkgs.stdenv.mkDerivation {
    pname = "rgbds";
    version = "1.0.4";
    src = src;

    nativeBuildInputs = [
      pkgs.cmake
      pkgs.bison
      pkgs.pkg-config
      pkgs.libpng.dev
      pkgs.zlib.dev
    ];

    cmakeFlags = [
      "-DRGBDS_VERSION_STRING=v1.0.4"
    ];

  };

in
  rgbds

