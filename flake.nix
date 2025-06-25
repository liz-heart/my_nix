{
  description = "My modular NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
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
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/hosts/laptop.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.dominik = import ./nixos/home/laptop.nix;
            }
          ];
        };
      };
    };
}
