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

    mw-libraries = pkgs.callPackage ./metroskrew/mw-libraries.nix {inherit pkgs;};

    pokegold = pkgs.callPackage ./pokegold/pokegold.nix {inherit pkgs rgbds;};
    pokeheartgold = pkgs.callPackage ./pokeheartgold/pokeheartgold.nix {inherit pkgs metroskrew mw-libraries;};
    pokeplatinum = pkgs.callPackage ./pokeplatinum/pokeplatinum.nix {inherit pkgs metroskrew mw-libraries;};
    pokeyellow = pkgs.callPackage ./pokeyellow/pokeyellow.nix {inherit pkgs rgbds;};
    pokered = pkgs.callPackage ./pokered/pokered.nix {inherit pkgs rgbds;};

  in {

    packages."${system}" = {

      # libraries
      inherit rgbds metroskrew mw-libraries;

      # pokegold
      pokegold = pokegold.pokegold;
      pokesilver = pokegold.pokesilver;
      pokegold-debug = pokegold.pokegold-debug;
      pokesilver-debug = pokegold.pokesilver-debug;

      # pokeheartgold
      pokeheartgold = pokeheartgold.pokeheartgold;
      pokesoulsilver = pokeheartgold.pokesoulsilver;

      # pokeplatinum
      pokeplatinum = pokeplatinum.pokeplatinum;

      # pokeyellow
      pokeyellow = pokeyellow.pokeyellow;
      pokeyellow-debug = pokeyellow.pokeyellow-debug;

      # pokered
      pokered = pokered.pokered;
      pokeblue = pokered.pokeblue;
      pokeblue-debug = pokered.pokeblue-debug;

    };

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
