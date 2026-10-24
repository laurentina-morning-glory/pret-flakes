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

  src = pkgs.fetchFromGitHub {
    owner = "mid-kid";
    repo = "mw-libraries";
    rev = "f0f7b14e4298741e3d924410b43e798c14c4ca32";
    hash = "sha256-cCis9OM5DSDgAmkfJm5UktkDseDqpPZBXQE8i2jCRrg=";
  };

  mw-libraries = pkgs.stdenv.mkDerivation {
    pname = "mw-libraries";
    version = "f0f7b14";
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

in
  mw-libraries
