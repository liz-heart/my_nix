{
  description = "My modular NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          devShells.default = pkgs.mkShell {
            name = "my-devshell";
            buildInputs = [
              pkgs.git
              pkgs.vim
              pkgs.curl
              pkgs.nodejs
              pkgs.php
              pkgs.docker
            ];
            shellHook = ''
              echo "👋 Welcome to your dev shell!"
            '';
          };
          formatter = pkgs.nixpkgs-fmt;
        }
      ) // {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./nixos/hosts/nixos.nix ];
        };
      };
    };
}
