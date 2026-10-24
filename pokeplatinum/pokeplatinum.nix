# Builds the ROM from the decomp

{
  pkgs ? import <nixpkgs> {},
  metroskrew ? pkgs.callPackage ../metroskrew.nix {inherit pkgs;},
  mw-libraries ? pkgs.callPackage ../mw-libraries.nix {inherit pkgs;},
}: let

  meson = pkgs.fetchFromGitHub {
    owner = "mesonbuild";
    repo = "meson";
    tag = "1.12.0";
    hash = "sha256-lnuySM7aCojPU9bQI7LPKgod8otFa+Spo9yIDFbOJVs=";
  };

  nitro-sdk = pkgs.fetchFromGitHub {
    owner = "ntrtwl";
    repo = "NitroSDK";
    rev = "eaae40f199c0a8827947afbc33227b6ba2f9d45c";
    hash = "sha256-vQslc9wNAfKUk1EnL6GaiYFHgkr2Jn2MBJLVKvUlCl4=";
  };

  nitro-system = pkgs.fetchFromGitHub {
    owner = "ntrtwl";
    repo = "NitroSystem";
    rev = "21c8fd078fdda34f3c2622ef0751d00adaacf890";
    hash = "sha256-Iaz5llYIOpJv+ohfnbyEaosMkK08EyFkXx/DJoCK0U8=";
  };

  nitro-wifi = pkgs.fetchFromGitHub {
    owner = "ntrtwl";
    repo = "NitroWifi";
    rev = "e6048fc294480831e154b3d53205d6cbda1775cd";
    hash = "sha256-LWjaNATIDijZ7EJxJg3zFkpQXPmUeR/grJgcLC0a8hY=";
  };

  nitro-dwc = pkgs.fetchFromGitHub {
    owner = "ntrtwl";
    repo = "NitroDWC";
    rev = "ba548986500a6628ec37c0603bdb94245ff12a63";
    hash = "sha256-zPlbcsSzNi6XeAuomdyPgKX/r+ZjZ512YTcEmOUq5Gg=";
  };

  libvct = pkgs.fetchFromGitHub {
    owner = "ntrtwl";
    repo = "libvct";
    rev = "dfcd1b2609c1711aa2b33590a2088687f9db2286";
    hash = "sha256-C5FcV1cBJEYBVTKxFF1ggyoH308jHMf8s+cJYZNuRMk=";
  };

  metang = pkgs.fetchFromGitHub {
    owner = "lhearachel";
    repo = "metang";
    tag = "v0.2.0-python";
    hash = "sha256-QN0VHsqDkU2zRTwIP1xyd8LYlrdZCXDuGwEdURX3B0E=";
  };

  rapidjson-src = pkgs.fetchurl {
    url = "https://github.com/Tencent/rapidjson/archive/v1.1.0.tar.gz";
    hash = "sha256-v3ztKXBKHmlvvM8qK06gaOd3T6N/bX3UA50Hh/i+2Y4=";
  };

  rapidjson-patch = pkgs.fetchurl {
    url = "https://wrapdb.mesonbuild.com/v2/rapidjson_1.1.0-2/get_patch";
    hash = "sha256-wUgNDs7wnbqktNhdhgkCBThvssfof08ViyDbvaFMmvw=";
  };

  yyjson-src = pkgs.fetchurl {
    url = "https://github.com/ibireme/yyjson/archive/refs/tags/0.12.0.tar.gz";
    hash = "sha256-sWJG9heyoTbHjXPl4mR8bx3hMT5GZ4BimFvc8fQLt10=";
  };

  yyjson-patch = pkgs.fetchurl {
    url = "https://wrapdb.mesonbuild.com/v2/yyjson_0.12.0-1/get_patch";
    hash = "sha256-AUWCsyjhNnHepk/LSaeV5wFCNgIWpQUhK4BFE0eBs7U=";
  };

  src = pkgs.fetchFromGitHub {
    owner = "pret";
    repo = "pokeplatinum";
    rev = "49f78f35ccd8c6880e189d23a630eef2976c44ac";
    hash = "sha256-wzcyhDPhE6XKzKwf9c5vvOI56E+OY/lXm+eGxh9WgYo=";
  };

  pokeplatinum = pkgs.stdenv.mkDerivation {
    pname = "pokeplatinum";
    version = "49f78f3";
    src = src;

    nativeBuildInputs = [
      pkgs.python3
      pkgs.flex
      pkgs.bison
      pkgs.unzip
      pkgs.pkg-config
      pkgs.libpng.dev
      # arm-none-eabi-gcc
      pkgs.gcc-arm-embedded
      pkgs.ninja
    ];

    patchPhase = ''

      mkdir -p tools/metroskrew
      cp -r ${metroskrew}/* tools/metroskrew
      chmod -R +w tools/metroskrew
      cp -r ${mw-libraries}/* tools/metroskrew

      cp -r "${meson}" subprojects/meson-1.12.0

      patchShebangs subprojects/meson-1.12.0/meson.py

      mkdir -p subprojects
      cp -r "${nitro-sdk}" subprojects/NitroSDK-4.2.30001
      cp -r "${nitro-system}" subprojects/NitroSystem-071126.1
      cp -r "${nitro-wifi}" subprojects/NitroWiFi-2.1.30003
      cp -r "${nitro-dwc}" subprojects/NitroDWC-2.2.30008
      cp -r "${libvct}" subprojects/libvct-1.3.1
      cp -r "${metang}" subprojects/metang

      tar -xf "${rapidjson-src}" -C subprojects

      mkdir -p _unpack_rapidjson_patch
      unzip -d _unpack_rapidjson_patch "${rapidjson-patch}"
      mv _unpack_rapidjson_patch/rapidjson-1.1.0/* subprojects/rapidjson-1.1.0
      rm -rf _unpack_rapidjson_patch

      patch -d subprojects/rapidjson-1.1.0 -p1 < subprojects/packagefiles/rapidjson_patch/000-pr719.patch
      patch -d subprojects/rapidjson-1.1.0 -p1 < subprojects/packagefiles/rapidjson_patch/001-pr1137.patch
      patch -d subprojects/rapidjson-1.1.0 -p1 < subprojects/packagefiles/rapidjson_patch/002-pr1323.patch

      tar -xf "${yyjson-src}" -C subprojects

      mkdir -p _unpack_yyjson_patch
      unzip -d _unpack_yyjson_patch "${yyjson-patch}"
      mv _unpack_yyjson_patch/yyjson-0.12.0/* subprojects/yyjson-0.12.0
      rm -rf _unpack_yyjson_patch

      patch -d subprojects/yyjson-0.12.0 -p1 < subprojects/packagefiles/yyjson_patch/always-native.patch
      patch -d subprojects/yyjson-0.12.0 -p1 < subprojects/packagefiles/yyjson_patch/fix-trailing-comma-errpos.patch
      patch -d subprojects/yyjson-0.12.0 -p1 < subprojects/packagefiles/yyjson_patch/feat-value-spans.patch
      patch -d subprojects/yyjson-0.12.0 -p1 < subprojects/packagefiles/yyjson_patch/arm-f64_pow10_table-unused.patch

      sed -i '142i\
-Dbuild.pkg_config_path=${pkgs.libpng.dev}/lib/pkgconfig \\' Makefile

      patchShebangs tools/postconf/postconf.py
      patchShebangs tools/scripts/*.py
      patchShebangs tools/scripts/*.sh
      patchShebangs tools/ordergen/*.py
      patchShebangs tools/jsoncnv/*.py

      patchShebangs subprojects/metang/metang.py

    '';

    buildPhase = ''
      make rom
    '';

    installPhase = ''
      mkdir -p "$out"
      mv build/pokeplatinum.us.nds "$out"
    '';

  };

in
  pokeplatinum
