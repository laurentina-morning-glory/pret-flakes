{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
}: let

  agbcc-src-rev = "da598c1d918402c42c0c0d7128ba14567f3175e9";

  agbcc-src = pkgs.fetchFromGitHub {
    owner = "pret";
    repo = "agbcc";
    rev = "da598c1d918402c42c0c0d7128ba14567f3175e9";
    hash = "sha256-/7SM2bRuz44WQiomMYqkf4pXge0ypSNViVu26FnEi2Q=";
  };

  agbcc = pkgs.stdenv.mkDerivation {

    pname = "agbcc";
    src = agbcc-src;
    version = agbcc-src-rev;

    buildInputs = [
      pkgs.pkgsCross.arm-embedded.buildPackages.binutils
    ];

    buildPhase = ''
      bash build.sh
    '';

    installPhase = ''
      mkdir -p "$out"
      bash install.sh "$out"
    '';

  };

  src-rev = "5784633ce4ef7ade1a7f2d2d0c288e3d5e6cdd7f";

  src = pkgs.fetchFromGitHub {
    owner = "pret";
    repo = "pokeruby";
    rev = src-rev;
    hash = "sha256-ld7FuxNwhzPoSg9N8DKtlUrEnGwZ6zcfIjrHXkIrVn8=";
  };

  pokeruby-bin2c = pkgs.stdenv.mkDerivation {
    pname = "pokeruby-bin2c";
    version = src-rev;
    src = src;
    buildPhase = ''make -C tools/bin2c'';
    installPhase = ''mkdir -p "$out"/bin && mv tools/bin2c/bin2c "$out"/bin'';
  };

  pokeruby-gbafix = pkgs.stdenv.mkDerivation {
    pname = "pokeruby-gbafix";
    version = src-rev;
    src = src;
    buildPhase = ''make -C tools/gbafix'';
    installPhase = ''mkdir -p "$out"/bin && mv tools/gbafix/gbafix "$out"/bin'';
  };

  pokeruby-gbagfx = pkgs.stdenv.mkDerivation {
    pname = "pokeruby-gbagfx";
    version = src-rev;
    src = src;
    nativeBuildInputs = [
      pkgs.libpng.dev
      pkgs.pkg-config
    ];
    buildPhase = ''make -C tools/gbagfx'';
    installPhase = ''mkdir -p "$out"/bin && mv tools/gbagfx/gbagfx "$out"/bin'';
  };

  pokeruby-scaninc = pkgs.stdenv.mkDerivation {
    pname = "pokeruby-scaninc";
    version = src-rev;
    src = src;
    buildPhase = ''make -C tools/scaninc'';
    installPhase = ''mkdir -p "$out"/bin && mv tools/scaninc/scaninc "$out"/bin'';
  };

  mkRuby = {
    target,
    pname ? target,
    sha1file ? target + ".sha1",
    is-de ? false,
  }: pkgs.stdenv.mkDerivation {

    pname = pname;
    version = src-rev;
    src = src;

    doCheck = true;

    nativeBuildInputs = [

      agbcc
      pokeruby-bin2c
      pokeruby-gbafix
      pokeruby-gbagfx
      pokeruby-scaninc

      # arm-none-eabi-as
      pkgs.gcc-arm-embedded
      pkgs.pkg-config
      pkgs.libpng.dev
    ]
      ++ lib.optionals is-de [ pkgs.rsync ]
    ;

    patchPhase = ''
      cp -r "${agbcc}"/tools .
      cp "${pokeruby-bin2c}"/bin/bin2c tools/bin2c
      cp "${pokeruby-gbafix}"/bin/gbafix tools/gbafix
      cp "${pokeruby-gbagfx}"/bin/gbagfx tools/gbagfx
      cp "${pokeruby-scaninc}"/bin/scaninc tools/scaninc
      ${if is-de then "bash de_before.sh " else ""}
    '';

    buildPhase = ''
      make SHELL="${pkgs.bash}/bin/bash -o pipefail" '${target}'
    '';

    checkPhase = ''
      sha1sum ${sha1file}
    '';

    installPhase = ''
      mkdir -p "$out"
      mv *.gba "$out"
    '';

  };

  ruby           = mkRuby { target = "ruby";           };
  ruby-debug     = mkRuby { target = "ruby_debug";     };
  ruby-rev1      = mkRuby { target = "ruby_rev1";      };
  ruby-rev2      = mkRuby { target = "ruby_rev2";      };
  sapphire       = mkRuby { target = "sapphire";       };
  sapphire-debug = mkRuby { target = "sapphire_debug"; };
  sapphire-rev1  = mkRuby { target = "sapphire_rev1";  };
  sapphire-rev2  = mkRuby { target = "sapphire_rev2";  };

  ruby-de           = mkRuby { is-de = true; target = "ruby_de";           };
  ruby-de-debug     = mkRuby { is-de = true; target = "ruby_de_debug";     };
  ruby-de-rev1      = mkRuby { is-de = true; target = "ruby_de_rev1";      };
  sapphire-de       = mkRuby { is-de = true; target = "sapphire_de";       };
  sapphire-de-debug = mkRuby { is-de = true; target = "sapphire_de_debug"; };
  sapphire-de-rev1  = mkRuby { is-de = true; target = "sapphire_de_rev1";  };

  ruby-sapphire-all = pkgs.stdenv.mkDerivation {
    name = "pokeruby-all";
    unpackPhase = ''
      mkdir -p "$out"
      cp "${ruby}"/*.gba "$out"
      cp "${ruby-debug}"/*.gba "$out"
      cp "${ruby-rev1}"/*.gba "$out"
      cp "${ruby-rev2}"/*.gba "$out"
      cp "${sapphire}"/*.gba "$out"
      cp "${sapphire-debug}"/*.gba "$out"
      cp "${sapphire-rev1}"/*.gba "$out"
      cp "${sapphire-rev2}"/*.gba "$out"
      cp "${ruby-de}"/*.gba "$out"
      cp "${ruby-de-debug}"/*.gba "$out"
      cp "${ruby-de-rev1}"/*.gba "$out"
      cp "${sapphire-de}"/*.gba "$out"
      cp "${sapphire-de-debug}"/*.gba "$out"
      cp "${sapphire-de-rev1}"/*.gba "$out"
    '';
  };

in
  {
    derivations = {
      inherit
        ruby
        ruby-debug
        ruby-rev1
        ruby-rev2
        sapphire
        sapphire-debug
        sapphire-rev1
        sapphire-rev2
        ruby-de
        ruby-de-debug
        ruby-de-rev1
        sapphire-de
        sapphire-de-debug
        sapphire-de-rev1

        ruby-sapphire-all
        ;
    };
  }
