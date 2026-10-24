{
  description = "pret/pokeheartgold";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = inputs: let

    system = "x86_64-linux";

    pkgs = inputs.nixpkgs.legacyPackages."${system}";

    metroskrew = pkgs.callPackage ../metroskrew/metroskrew.nix {inherit pkgs;};

    mw-libraries = pkgs.callPackage ../metroskrew/mw-libraries.nix {inherit pkgs;};

    pokeheartgold_packages = pkgs.callPackage ./pokeheartgold.nix {inherit pkgs metroskrew mw-libraries;};

    pokeheartgold = pokeheartgold_packages.pokeheartgold;
    pokesoulsilver = pokeheartgold_packages.pokesoulsilver;

    demo-pokeheartgold = pkgs.writeShellScript "demo-pokeheartgold" ''
      exec ${pkgs.desmume}/bin/desmume ${pokeheartgold}/pokeheartgold.us.nds
    '';

    demo-pokesoulsilver = pkgs.writeShellScript "demo-pokesoulsilver" ''
      exec ${pkgs.desmume}/bin/desmume ${pokesoulsilver}/pokesoulsilver.us.nds
    '';

  in {

    packages."${system}" = {
      default = pokeheartgold;
      pokeheartgold = pokeheartgold;
      pokesoulsilver = pokesoulsilver;
    };

    devShells."${system}".default = pkgs.mkShell {
      inputsFrom = [
        pokeheartgold
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

    apps."${system}" = {
      default = {
        type = "app";
        program = "${demo-pokeheartgold}";
      };
      pokeheartgold = {
        type = "app";
        program = "${demo-pokeheartgold}";
      };
      pokesoulsilver = {
        type = "app";
        program = "${demo-pokesoulsilver}";
      };
    };

  };
}

