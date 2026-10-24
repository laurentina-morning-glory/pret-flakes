{
  description = "pret/pokeplatinum";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = inputs: let

    system = "x86_64-linux";

    pkgs = inputs.nixpkgs.legacyPackages."${system}";

    metroskrew = pkgs.callPackage ../metroskrew/metroskrew.nix {inherit pkgs;};

    mw-libraries = pkgs.callPackage ../metroskrew/mw-libraries.nix {inherit pkgs;};

    pokeplatinum = pkgs.callPackage ./pokeplatinum.nix {inherit pkgs metroskrew mw-libraries;};

    demo-pokeplatinum = pkgs.writeShellScript "demo-pokeplatinum" ''
      exec ${pkgs.desmume}/bin/desmume ${pokeplatinum}/pokeplatinum.us.nds
    '';

  in {

    packages."${system}".default = pokeplatinum;

    devShells."${system}".default = pkgs.mkShell {

      inputsFrom = [
        pokeplatinum
      ];

      packages = [
        pkgs.pre-commit
        # clang-format
        pkgs.clang-tools

        metroskrew
        mw-libraries
      ];

      # Use `pret_pokeplatinum_install_metroskrew` to copy the metroskrew binaries.
      #
      # Use the `meson` alias to invoke the local meson python script.
      # e.g., `meson --reconfigure build`
      shellHook = ''
        export METROSKREW="${metroskrew}"
        export MW_LIBRARIES="${mw-libraries}"
        export LIBPNG="${pkgs.libpng.dev}"

        pret_pokeplatinum_install_metroskrew() {
          mkdir -p tools/metroskrew
          chmod -R +w tools/metroskrew
          cp -r "$METROSKREW"/* tools/metroskrew
          chmod -R +w tools/metroskrew
          cp -r "$MW_LIBRARIES"/* tools/metroskrew
          chmod -R +w tools/metroskrew
        }

        meson() {
          ./subprojects/meson-1.12.0/meson.py "$@"
        }
      '';

    };

    apps."${system}".default = {
      type = "app";
      program = "${demo-pokeplatinum}";
    };

  };
}
