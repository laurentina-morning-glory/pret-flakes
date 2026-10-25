{
  description = "pret/pokegold";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = inputs: let

    system = "x86_64-linux";

    pkgs = inputs.nixpkgs.legacyPackages."${system}";

    rgbds = pkgs.callPackage ../rgbds/rgbds.nix {inherit pkgs;};

    pokegold-packages = pkgs.callPackage ./pokegold.nix {inherit pkgs rgbds;};

    pokegold = pokegold-packages.pokegold;
    pokesilver = pokegold-packages.pokesilver;
    pokegold-debug = pokegold-packages.pokegold-debug;
    pokesilver-debug = pokegold-packages.pokesilver-debug;

    writeMesenWrapper = { poke }: pkgs.writeShellScript "mesen-wrapper" ''
      exec ${pkgs.mesen}/bin/Mesen ${poke}/*.gbc
    '';

    createMesenWrapperApp = { poke }: let
      script = writeMesenWrapper {inherit poke;};
    in {
      type = "app";
      program = "${script}";
    };

  in {

    packages."${system}" = {
      inherit pokegold pokesilver pokegold-debug pokesilver-debug;
      default = pokegold;
    };

    devShells."${system}".default = pkgs.mkShell {
      inputsFrom = [
        pokegold
      ];
    };

    apps."${system}" = {
      default = createMesenWrapperApp {poke=pokegold;};
      pokegold = createMesenWrapperApp {poke=pokegold;};
      pokesilver = createMesenWrapperApp {poke=pokesilver;};
      pokegold-debug = createMesenWrapperApp {poke=pokegold-debug;};
      pokesilver-debug = createMesenWrapperApp {poke=pokesilver-debug;};
    };

  };
}
