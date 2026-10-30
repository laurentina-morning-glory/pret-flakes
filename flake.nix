{
  description = "pret/pokered";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = inputs: let

    system = "x86_64-linux";

    pkgs = inputs.nixpkgs.legacyPackages."${system}";

    rgbds = pkgs.callPackage ./rgbds/rgbds.nix {inherit pkgs;};

    metroskrew = pkgs.callPackage ./metroskrew/metroskrew.nix {inherit pkgs;};

    mw-libraries-packages = pkgs.callPackage ./metroskrew/mw-libraries.nix {inherit pkgs;};

    pokecrystal = pkgs.callPackage ./pokecrystal/pokecrystal.nix {inherit pkgs rgbds;};
    pokegold = pkgs.callPackage ./pokegold/pokegold.nix {inherit pkgs rgbds;};
    pokeheartgold = pkgs.callPackage ./pokeheartgold/pokeheartgold.nix {inherit pkgs metroskrew mw-libraries-packages;};
    pokeplatinum = pkgs.callPackage ./pokeplatinum/pokeplatinum.nix {inherit pkgs metroskrew mw-libraries-packages;};
    pokeyellow = pkgs.callPackage ./pokeyellow/pokeyellow.nix {inherit pkgs rgbds;};
    pokered = pkgs.callPackage ./pokered/pokered.nix {inherit pkgs rgbds;};

  in {

    packages."${system}" = {
      inherit rgbds metroskrew;
    }
      // mw-libraries-packages
      // pokecrystal
      // pokegold
      // pokeheartgold
      // pokeplatinum
      // pokeyellow
      // pokered
      ;

    devShells."${system}" = {

      pokegold = pkgs.mkShell {
        inputsFrom = [ pokegold.pokegold ];
      };

      pokeheartgold = pkgs.mkShell {
        inputsFrom = [ pokeheartgold.pokeheartgold ];
      };

      pokeplatinum = pokeplatinum.shell;

      pokeyellow = pkgs.mkShell {
        inputsFrom = [ pokeyellow.pokeyellow ];
      };

      pokered = pkgs.mkShell {
        inputsFrom = [ pokered.pokered ];
      };

    };

  };
}
