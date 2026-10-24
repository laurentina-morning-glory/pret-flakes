{pkgs ? import <nixpkgs> {}}: let

  # https://github.com/mid-kid/metroskrew/blob/0.1.3/subprojects/wine.wrap
  subproject-wine = pkgs.fetchurl {
    url = "https://dl.winehq.org/wine/source/10.0/wine-10.0.tar.xz";
    hash = "sha256-xeCz9ffvr7MOnNTZxiS4XFgxcdM1SdkzzTQC80GsNgE=";
  };

  # https://github.com/mid-kid/metroskrew/blob/0.1.3/subprojects/mw-executables.wrap
  subproject-mw-executables = pkgs.fetchurl {
    url = "https://github.com/luckytyphlosion/mw-executables/archive/3d63e4737672c094ea697d229b5d6f1456004f34.tar.gz";
    hash = "sha256-qL34tWx043sHjwbhsddFY/JC1kPG5N4ZLckMXZagnfQ=";
  };

  src = pkgs.fetchFromGitHub {
    owner = "mid-kid";
    repo = "metroskrew";
    tag = "0.1.3";
    fetchSubmodules = false;
    #hash = "sha256-2Usnoh0rVURjxbMeX8MJsSYNy+cqjzthPHONJs3fu/o=";
    hash = "sha256-A1wXMgchW8OvKGiMLARVSz/9GzpwXWHiiYECPQQmnwM=";
  };

  metroskrew = pkgs.pkgsi686Linux.stdenv.mkDerivation {
    pname = "metroskrew";
    version = "0.1.3";
    src = src;

    nativeBuildInputs = with pkgs; [
      gnumake
      meson
      bison
      flex
      ninja
    ];

    postPatch = ''
      mkdir -p subprojects

      tar -xf ${subproject-wine} -C subprojects
      cp -r subprojects/packagefiles/wine-10.0/* subprojects/wine-10.0

      tar -xf ${subproject-mw-executables} -C subprojects
      cp -r subprojects/packagefiles/mw-executables/* subprojects/mw-executables-3d63e4737672c094ea697d229b5d6f1456004f34
    '';

    configurePhase = ''
      make setup_release
    '';

    buildPhase = ''
      make package_release
    '';

    installPhase = ''
      mv build/opt.release/install "$out"
    '';
  };

in
  metroskrew
