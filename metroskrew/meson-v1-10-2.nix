{pkgs ? import <nixpkgs> {} }: let

  version = "1.10.2";

  src = pkgs.fetchFromGitHub {
    owner = "mesonbuild";
    repo = "meson";
    tag = version;
    hash = "sha256-3Zeavn6aW6920gM7yE73Ms1RPCP2GjX9IUL9YGmISfY=";
  };

  meson = pkgs.stdenv.mkDerivation {
    pname = "meson";
    version = version;
    src = src;
    installPhase = ''
      mkdir -p "$out"
      mv * "$out"
    '';
  };

  wrapper = pkgs.writeShellScriptBin "meson" ''
    exec ${pkgs.python3}/bin/python3 ${meson}/meson.py "$@"
  '';

in
  wrapper
