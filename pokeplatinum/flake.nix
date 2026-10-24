{
  description = "pret/pokeplatinum";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = inputs: let

    system = "x86_64-linux";

    pkgs = inputs.nixpkgs.legacyPackages."${system}";

    metroskrew = pkgs.callPackage ../metroskrew.nix {inherit pkgs;};

    mw-libraries = pkgs.callPackage ../mw-libraries.nix {inherit pkgs;};

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
        metroskrew
        mw-libraries
      ];
      shellHook = ''
        export METROSKREW="${metroskrew}"
        export MW_LIBRARIES="${mw-libraries}"
        export LIBPNG="${pkgs.libpng.dev}"
      '';
    };

    apps."${system}".default = {
      type = "app";
      program = "${demo-pokeplatinum}";
    };

  };
}
