{pkgs ? import <nixpkgs> {} }: let

  metroskrew = pkgs.callPackage ./metroskrew.nix {inherit pkgs;};

  meson = pkgs.callPackage ./meson-v1-10-2.nix {inherit pkgs;};

  # https://github.com/mid-kid/mw-libraries/blob/f0f7b14e4298741e3d924410b43e798c14c4ca32/libvers.txt
  libvers = [
    "dsi/1.6sp1"
    "dsi/1.3"
    "dsi/1.2"
    "dsi/1.1p1"
    "dsi/1.1"
    "ds/2.0/sp2p3"
    "ds/2.0/sp2"
    "ds/2.0/sp1p2"
    "ds/2.0/sp1"
    "ds/2.0/p4"
    "ds/2.0/p2"
    "ds/2.0/base"
    "ds/1.2/sp4"
    "ds/1.2/sp3"
    "ds/1.2/sp2"
    "ds/1.2/base_b73"
    "ds/1.2/base"
  ];

  src-rev = "f0f7b14e4298741e3d924410b43e798c14c4ca32";

  src = pkgs.fetchFromGitHub {
    owner = "mid-kid";
    repo = "mw-libraries";
    rev = src-rev;
    hash = "sha256-cCis9OM5DSDgAmkfJm5UktkDseDqpPZBXQE8i2jCRrg=";
  };

  common = {

    version = src-rev;
    src = src;

    nativeBuildInputs = [
      pkgs.gnumake
      pkgs.m4
      pkgs.ninja

      meson
      metroskrew
    ];

    configurePhase = ''
      true
    '';

    buildPhase = ''
      libvers="${pkgs.lib.escapeShellArgs libvers}"
      for libver in $libvers; do
        make libver="$libver" package
      done
    '';

    installPhase = ''
      mv build/install "$out"
    '';
  };

  mw-libraries-dsi-1-6-sp1     = pkgs.stdenv.mkDerivation (common // { name = "mw-libraries-dsi-1-6-sp1"    ; buildPhase = "make libver='dsi/1.6sp1'      package"; });
  mw-libraries-dsi-1-3         = pkgs.stdenv.mkDerivation (common // { name = "mw-libraries-dsi-1-3"        ; buildPhase = "make libver='dsi/1.3'         package"; });
  mw-libraries-dsi-1-2         = pkgs.stdenv.mkDerivation (common // { name = "mw-libraries-dsi-1-2"        ; buildPhase = "make libver='dsi/1.2'         package"; });
  mw-libraries-dsi-1-1p1       = pkgs.stdenv.mkDerivation (common // { name = "mw-libraries-dsi-1-1p1"      ; buildPhase = "make libver='dsi/1.1p1'       package"; });
  mw-libraries-dsi-1-1         = pkgs.stdenv.mkDerivation (common // { name = "mw-libraries-dsi-1-1"        ; buildPhase = "make libver='dsi/1.1'         package"; });
  mw-libraries-ds-2-0-sp2p3    = pkgs.stdenv.mkDerivation (common // { name = "mw-libraries-ds-2-0-sp2p3"   ; buildPhase = "make libver='ds/2.0/sp2p3'    package"; });
  mw-libraries-ds-2-0-sp2      = pkgs.stdenv.mkDerivation (common // { name = "mw-libraries-ds-2-0-sp2"     ; buildPhase = "make libver='ds/2.0/sp2'      package"; });
  mw-libraries-ds-2-0-sp1p2    = pkgs.stdenv.mkDerivation (common // { name = "mw-libraries-ds-2-0-sp1p2"   ; buildPhase = "make libver='ds/2.0/sp1p2'    package"; });
  mw-libraries-ds-2-0-sp1      = pkgs.stdenv.mkDerivation (common // { name = "mw-libraries-ds-2-0-sp1"     ; buildPhase = "make libver='ds/2.0/sp1'      package"; });
  mw-libraries-ds-2-0-p4       = pkgs.stdenv.mkDerivation (common // { name = "mw-libraries-ds-2-0-p4"      ; buildPhase = "make libver='ds/2.0/p4'       package"; });
  mw-libraries-ds-2-0-p2       = pkgs.stdenv.mkDerivation (common // { name = "mw-libraries-ds-2-0-p2"      ; buildPhase = "make libver='ds/2.0/p2'       package"; });
  mw-libraries-ds-2-0-base     = pkgs.stdenv.mkDerivation (common // { name = "mw-libraries-ds-2-0-base"    ; buildPhase = "make libver='ds/2.0/base'     package"; });
  mw-libraries-ds-1-3-sp4      = pkgs.stdenv.mkDerivation (common // { name = "mw-libraries-ds-1-3-sp4"     ; buildPhase = "make libver='ds/1.2/sp4'      package"; });
  mw-libraries-ds-1-3-sp3      = pkgs.stdenv.mkDerivation (common // { name = "mw-libraries-ds-1-3-sp3"     ; buildPhase = "make libver='ds/1.2/sp3'      package"; });
  mw-libraries-ds-1-3-sp2      = pkgs.stdenv.mkDerivation (common // { name = "mw-libraries-ds-1-3-sp2"     ; buildPhase = "make libver='ds/1.2/sp2'      package"; });
  mw-libraries-ds-1-3-base-b73 = pkgs.stdenv.mkDerivation (common // { name = "mw-libraries-ds-1-3-base-b73"; buildPhase = "make libver='ds/1.2/base_b73' package"; });
  mw-libraries-ds-1-2          = pkgs.stdenv.mkDerivation (common // { name = "mw-libraries-ds-1-2"         ; buildPhase = "make libver='ds/1.2/base'     package"; });

  mw-libraries-all-dsi = pkgs.stdenv.mkDerivation {
    version = src-rev;
    name = "mw-libraries-all-dsi";
    unpackPhase = ''
      mkdir -p "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-dsi-1-6-sp1}"/*     "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-dsi-1-3}"/*         "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-dsi-1-2}"/*         "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-dsi-1-1p1}"/*       "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-dsi-1-1}"/*         "$out"
    '';
  };

  mw-libraries-all-ds = pkgs.stdenv.mkDerivation {
    version = src-rev;
    name = "mw-libraries-all-ds";
    unpackPhase = ''
      mkdir -p "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-ds-2-0-sp2p3}"/*    "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-ds-2-0-sp2}"/*      "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-ds-2-0-sp1p2}"/*    "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-ds-2-0-sp1}"/*      "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-ds-2-0-p4}"/*       "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-ds-2-0-p2}"/*       "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-ds-2-0-base}"/*     "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-ds-1-3-sp4}"/*      "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-ds-1-3-sp3}"/*      "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-ds-1-3-sp2}"/*      "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-ds-1-3-base-b73}"/* "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-ds-1-2}"/*          "$out"
    '';
  };

  mw-libraries-all = pkgs.stdenv.mkDerivation {
    version = src-rev;
    name = "mw-libraries-all";
    unpackPhase = ''
      mkdir -p "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-all-dsi}"/* "$out"
      chmod -R +w "$out" && cp -r "${mw-libraries-all-ds}"/*  "$out"
    '';
  };

in
  {
    inherit
      mw-libraries-dsi-1-6-sp1
      mw-libraries-dsi-1-3
      mw-libraries-dsi-1-2
      mw-libraries-dsi-1-1p1
      mw-libraries-dsi-1-1
      mw-libraries-ds-2-0-sp2p3
      mw-libraries-ds-2-0-sp2
      mw-libraries-ds-2-0-sp1p2
      mw-libraries-ds-2-0-sp1
      mw-libraries-ds-2-0-p4
      mw-libraries-ds-2-0-p2
      mw-libraries-ds-2-0-base
      mw-libraries-ds-1-3-sp4
      mw-libraries-ds-1-3-sp3
      mw-libraries-ds-1-3-sp2
      mw-libraries-ds-1-3-base-b73
      mw-libraries-ds-1-2

      mw-libraries-all-dsi
      mw-libraries-all-ds
      mw-libraries-all
      ;
  }
