{ config, pkgs, ... }:

{
  # Enable Flakes and nix-command for everyone
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System packages for all hosts
  environment.systemPackages = with pkgs; [
    gparted

    # tools
    unzip
    vim
    curl
    wget

    # dev
    vscode
    android-studio
    jetbrains.idea-community-bin

    # git
    gitFull

    # multimedia
    vesktop

  ];

  # Set timezone
  time.timeZone = "Europe/Vienna";

  # Example: default editor
  programs.vim.defaultEditor = true;
}
