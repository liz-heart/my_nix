{
  description = "My modular NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # ✅ Hyprland hinzufügen
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, hyprland, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          pip
          requests
        ]);
      in
      {
        devShells = {
          default = pkgs.mkShell {
            name = "my-devshell";
            buildInputs = [
              pkgs.php83
              pkgs.php83Packages.composer
              pkgs.nodejs_18
              pkgs.sqlite
              pkgs.docker
              pythonEnv
            ];
            shellHook = ''
              echo "PHP/Laravel, Python development shell ready"
            '';
          };

          angular = pkgs.mkShell {
            name = "angular-shell";
            buildInputs = [
              pkgs.nodejs
              pkgs.yarn
              pkgs.git
            ];
            shellHook = ''
              echo "Angular development shell ready"
              echo "Use 'npx @angular/cli new my-app' to create a new project"
            '';
          };

          java = pkgs.mkShell {
            name = "java-shell";
            buildInputs = [
              pkgs.jdk21
              pkgs.maven
              pkgs.gradle
            ];
            shellHook = ''
              echo "✅ Java development shell ready"
              echo "🛠  Java: ${pkgs.jdk21}/bin/java"
              java -version
            '';
            JAVA_HOME = "${pkgs.jdk21}";
          };
        };

        formatter = pkgs.nixpkgs-fmt;

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

                home-manager.backupFileExtension = "backup";
              }
            ];

            # ✅ Inputs an Module übergeben
            specialArgs = {
              inputs = {
                hyprland = hyprland;
              };
            };
          };
        };
      }
    );
}
