{
  description = "pret/pokeyellow";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = inputs: let

    system = "x86_64-linux";

    pkgs = inputs.nixpkgs.legacyPackages."${system}";

    rgbds = pkgs.callPackage ../rgbds/rgbds.nix {inherit pkgs;};

    pokeyellow_packages = pkgs.callPackage ./pokeyellow.nix {inherit pkgs rgbds;};

    pokeyellow = pokeyellow_packages.pokeyellow;
    pokeyellow-debug = pokeyellow_packages.pokeyellow-debug;

    demo-pokeyellow = pkgs.writeShellScript "demo-pokeyellow" ''
      exec ${pkgs.mesen}/bin/Mesen ${pokeyellow}/pokeyellow.gbc
    '';

    demo-pokeyellow-debug = pkgs.writeShellScript "demo-pokeyellow-debug" ''
      exec ${pkgs.mesen}/bin/Mesen ${pokeyellow-debug}/pokeyellow_debug.gbc
    '';

  in {

    packages."${system}" = {
      default = pokeyellow;
      pokeyellow = pokeyellow;
      pokeyellow-debug = pokeyellow-debug;
    };

    devShells."${system}".default = pkgs.mkShell {
      inputsFrom = [
        pokeyellow
      ];
    };

    apps."${system}" = {
      default = {
        type = "app";
        program = "${demo-pokeyellow}";
      };
      pokeyellow = {
        type = "app";
        program = "${demo-pokeyellow}";
      };
      pokeyellow-debug = {
        type = "app";
        program = "${demo-pokeyellow-debug}";
      };
    };

  };
}

