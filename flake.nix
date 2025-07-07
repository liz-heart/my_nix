{
  description = "Modular NixOS setup with Home Manager, DevShells and Hyprland";

  inputs = {
    # Main NixOS channel (unstable)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Optional stable channel (e.g. for production-grade tools)
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    # flake-utils: multi-system support (e.g., x86_64, aarch64)
    flake-utils.url = "github:numtide/flake-utils";

    # Home Manager for user configuration
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland as a flake input (with submodule support)
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, flake-utils, home-manager, hyprland, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
    in flake-utils.lib.eachDefaultSystem (system: {
      # 💻 DevShells for development environments

      devShells.default = pkgs.mkShell {
        name = "default-devshell";
        buildInputs = [
          pkgs.php83
          pkgs.php83Packages.composer
          pkgs.nodejs_18
          pkgs.sqlite
          pkgs.docker
          (pkgs.python3.withPackages (ps: with ps; [ pip requests ]))
        ];
        shellHook = ''
          echo "🔧 PHP/Laravel + Python DevShell active"
        '';
      };

      devShells.angular = pkgs.mkShell {
        name = "angular-shell";
        buildInputs = [
          pkgs.nodejs
          pkgs.yarn
          pkgs.git
        ];
        shellHook = ''
          echo "🅰️ Angular DevShell active"
          echo "💡 npx @angular/cli new my-app"
        '';
      };

      devShells.java = pkgs.mkShell {
        name = "java-shell";
        buildInputs = [
          pkgs.jdk21
          pkgs.maven
          pkgs.gradle
        ];
        shellHook = ''
          echo "☕ Java DevShell active"
          java -version
        '';
        JAVA_HOME = "${pkgs.jdk21}";
      };

      # Formatter for Nix code
      formatter = pkgs.nixpkgs-fmt;
    }) // {
      # 🧩 NixOS system configuration
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/hosts/laptop.nix
          ./nixos/hardware/laptop.nix

          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            # User home-manager configs (in system)
            home-manager.users.dominik = import ./nixos/home/dominik/dominik.nix;
          }
        ];
        specialArgs = {
          inherit hyprland;
          desktopEnvironment = "hyprland";
        };
      };

      # 🏠 Home Manager standalone (for user environments without NixOS)
      homeConfigurations.dominik = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        modules = [
          ./nixos/home/dominik/dominik.nix
        ];
        extraSpecialArgs = {
          inherit hyprland;
          desktopEnvironment = "hyprland";

          obsidian = pkgs.callPackage ./nixos/packages/obsidian.nix {};
        };
      };

#      homeConfigurations.lizheart = home-manager.lib.homeManagerConfiguration {
 #       pkgs = import nixpkgs {
  #        system = "x86_64-linux";
   #       config.allowUnfree = true;
    #    };
     #   modules = [
      #    ./nixos/home/lizheart/lizheart.nix
       # ];
        #extraSpecialArgs = {
         # inherit hyprland;
          #desktopEnvironment = "plasma";
        #};
      #};
    };
}
