# Builds the ROM from the decomp

{
  pkgs ? import <nixpkgs> {},
  metroskrew ? pkgs.callPackage ../metroskrew/metroskrew.nix {inherit pkgs;},
  mw-libraries ? pkgs.callPackage ../metroskrew/mw-libraries.nix {inherit pkgs;},
}: let

  nitro-dwc = pkgs.fetchFromGitHub {
    owner = "ntrtwl";
    repo = "NitroDWC";
    rev = "9136bfa0bf3a5123ce560e6cd47017456e4c130b";
    hash = "sha256-FrrwgwmGlNaRXMlddXPx9IZs3mIaJYNiK5lz8Kaee64=";
  };

  nitro-sdk = pkgs.fetchFromGitHub {
    owner = "ntrtwl";
    repo = "NitroSDK";
    rev = "ccbbcc8b6db4c4dbba3d503d2026978d78977840";
    hash = "sha256-eqvNQVnuDgIOaDq+HA2vpV5c06gN/X6pE8xyScLiDK8=";
  };

  nitro-system = pkgs.fetchFromGitHub {
    owner = "ntrtwl";
    repo = "NitroSystem";
    rev = "d636fb5d2b212e8736f09859fff447be2bd0ac85";
    hash = "sha256-I9WztfNJvX43vFC2UyvYTXNWAFSaeyQTGTejcfdKeGE=";
  };

  nitro-wifi = pkgs.fetchFromGitHub {
    owner = "ntrtwl";
    repo = "NitroWifi";
    rev = "e6048fc294480831e154b3d53205d6cbda1775cd";
    hash = "sha256-LWjaNATIDijZ7EJxJg3zFkpQXPmUeR/grJgcLC0a8hY=";
  };

  libvct = pkgs.fetchFromGitHub {
    owner = "ntrtwl";
    repo = "libvct";
    rev = "dfcd1b2609c1711aa2b33590a2088687f9db2286";
    hash = "sha256-C5FcV1cBJEYBVTKxFF1ggyoH308jHMf8s+cJYZNuRMk=";
  };

  meson = pkgs.fetchFromGitHub {
    owner = "mesonbuild";
    repo = "meson";
    tag = "1.12.0";
    hash = "sha256-lnuySM7aCojPU9bQI7LPKgod8otFa+Spo9yIDFbOJVs=";
  };

  yyjson-src = pkgs.fetchurl {
    url = "https://github.com/ibireme/yyjson/archive/refs/tags/0.12.0.tar.gz";
    hash = "sha256-sWJG9heyoTbHjXPl4mR8bx3hMT5GZ4BimFvc8fQLt10=";
  };

  yyjson-patch = pkgs.fetchurl {
    url = "https://wrapdb.mesonbuild.com/v2/yyjson_0.12.0-1/get_patch";
    hash = "sha256-AUWCsyjhNnHepk/LSaeV5wFCNgIWpQUhK4BFE0eBs7U=";
  };

  src_repo = "pokeheartgold";
  src_rev = "6988158691eb6178cff697cda0428045ddcba5fb";

  src = pkgs.fetchFromGitHub {
    owner = "pret";
    repo = src_repo;
    rev = src_rev;
    hash = "sha256-nbJQ6OrRpPtw8TkrrGtNoz0yvwTVrhBYt8Vvvw6QhLM=";
  };

  common = {

    version = src_rev;
    src = src;

    doCheck = true;

    nativeBuildInputs = [
      pkgs.unzip
      pkgs.python3
      pkgs.flex
      pkgs.bison
      pkgs.pkg-config
      pkgs.libpng.dev
      # arm-none-eabi-gcc
      # arm-none-eabi-objcopy
      pkgs.gcc-arm-embedded
      pkgs.ninja
    ];

    postPatch = ''

      mkdir -p tools/metroskrew
      cp -r ${metroskrew}/* tools/metroskrew
      chmod -R +w tools/metroskrew
      cp -r ${mw-libraries}/* tools/metroskrew

      cp -r "${meson}" subprojects/meson-1.12.0

      patchShebangs subprojects/meson-1.12.0/meson.py

      mkdir -p subprojects
      cp -r "${nitro-dwc}" subprojects/NitroDWC-2.2.30008
      cp -r "${nitro-sdk}" subprojects/NitroSDK-4.2.30001
      cp -r "${nitro-system}" subprojects/NitroSystem-071126.1
      cp -r "${nitro-wifi}" subprojects/NitroWiFi-2.1.30003
      cp -r "${libvct}" subprojects/libvct-1.3.1

      tar -xf "${yyjson-src}" -C subprojects

      mkdir -p _unpack_yyjson_patch
      unzip -d _unpack_yyjson_patch "${yyjson-patch}"
      mv _unpack_yyjson_patch/yyjson-0.12.0/* subprojects/yyjson-0.12.0
      rm -rf _unpack_yyjson_patch

      patch -d subprojects/yyjson-0.12.0 -p1 < subprojects/packagefiles/yyjson_patch/always-native.patch
      patch -d subprojects/yyjson-0.12.0 -p1 < subprojects/packagefiles/yyjson_patch/fix-trailing-comma-errpos.patch
      patch -d subprojects/yyjson-0.12.0 -p1 < subprojects/packagefiles/yyjson_patch/feat-value-spans.patch
      patch -d subprojects/yyjson-0.12.0 -p1 < subprojects/packagefiles/yyjson_patch/arm-f64_pow10_table-unused.patch

      sed -i '135i\
-Dbuild.pkg_config_path=${pkgs.libpng.dev}/lib/pkgconfig \\' Makefile

      chmod +x tools/scripts/makescript_mw.sh
      patchShebangs tools/scripts/*.sh

    '';

    configurePhase = ''
      make setup_rom
    '';

    buildPhase = ''
      make rom
    '';

    checkPhase = ''
      make check
    '';

  };

  pokeheartgold = pkgs.stdenv.mkDerivation (common // {

    pname = "pokeheartgold";

    GAME_VERSION = "HEARTGOLD";

    installPhase = ''
      mkdir -p "$out"
      mv build/heartgold.us/pokeheartgold.us.nds "$out"
    '';

  });

  pokesoulsilver = pkgs.stdenv.mkDerivation (common // {

    pname = "pokesoulsilver";

    GAME_VERSION = "SOULSILVER";

    installPhase = ''
      mkdir -p "$out"
      mv build/soulsilver.us/pokesoulsilver.us.nds "$out"
    '';

  });

in
  {inherit pokeheartgold pokesoulsilver;}
