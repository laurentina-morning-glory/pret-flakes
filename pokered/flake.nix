{
  description = "pret/pokered";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = inputs: let

    system = "x86_64-linux";

    pkgs = inputs.nixpkgs.legacyPackages."${system}";

    rgbds = pkgs.callPackage ./rgbds.nix {inherit pkgs;};

    pokered_packages = pkgs.callPackage ./pokered.nix {inherit pkgs rgbds;};

    pokered = pokered_packages.pokered;
    pokeblue = pokered_packages.pokeblue;
    pokeblue-debug = pokered_packages.pokeblue-debug;

    demo-pokered = pkgs.writeShellScript "demo-pokered" ''
      exec ${pkgs.mesen}/bin/Mesen ${pokered}/pokered.gbc
    '';

    demo-pokeblue = pkgs.writeShellScript "demo-pokeblue" ''
      exec ${pkgs.mesen}/bin/Mesen ${pokeblue}/pokeblue.gbc
    '';

    demo-pokeblue-debug = pkgs.writeShellScript "demo-pokeblue-debug" ''
      exec ${pkgs.mesen}/bin/Mesen ${pokeblue-debug}/pokeblue_debug.gbc
    '';

  in {

    packages."${system}" = {
      default = pokered;
      pokered = pokered;
      pokeblue = pokeblue;
      pokeblue-debug = pokeblue-debug;
    };

    devShells."${system}".default = pkgs.mkShell {
      inputsFrom = [
        pokered
      ];
    };

    apps."${system}" = {
      default = {
        type = "app";
        program = "${demo-pokered}";
      };
      pokered = {
        type = "app";
        program = "${demo-pokered}";
      };
      pokeblue = {
        type = "app";
        program = "${demo-pokeblue}";
      };
      pokeblue-debug = {
        type = "app";
        program = "${demo-pokeblue-debug}";
      };
    };

  };
}

