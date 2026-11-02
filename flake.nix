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

    mw-libraries-all-ds = mw-libraries-packages.derivations.mw-libraries-all-ds;

    pokecrystal = pkgs.callPackage ./pokecrystal/pokecrystal.nix {inherit pkgs rgbds;};
    pokegold = pkgs.callPackage ./pokegold/pokegold.nix {inherit pkgs rgbds;};
    pokeheartgold = pkgs.callPackage ./pokeheartgold/pokeheartgold.nix {inherit pkgs metroskrew mw-libraries-all-ds;};
    pokeplatinum = pkgs.callPackage ./pokeplatinum/pokeplatinum.nix {inherit pkgs metroskrew mw-libraries-all-ds;};
    pokered = pkgs.callPackage ./pokered/pokered.nix {inherit pkgs rgbds;};
    pokeruby = pkgs.callPackage ./pokeruby/pokeruby.nix {inherit pkgs;};
    poketcg2 = pkgs.callPackage ./poketcg2/poketcg2.nix {inherit pkgs rgbds;};
    poketcg = pkgs.callPackage ./poketcg/poketcg.nix {inherit pkgs rgbds;};
    pokeyellow = pkgs.callPackage ./pokeyellow/pokeyellow.nix {inherit pkgs rgbds;};

  in {

    packages."${system}" = {
      inherit rgbds metroskrew;
    }
      // mw-libraries-packages.derivations
      // pokecrystal.derivations
      // pokegold.derivations
      // pokeheartgold.derivations
      // pokeplatinum.derivations
      // pokered.derivations
      // pokeruby.derivations
      // poketcg.derivations
      // poketcg2.derivations
      // pokeyellow.derivations
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

      pokeruby = pkgs.mkShell {
        inputsFrom = [ pokeruby.pokeruby ];
      };

      poketcg = pkgs.mkShell {
        inputsFrom = [ poketcg.poketcg ];
      };

    };

  };
}
