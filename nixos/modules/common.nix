{ config, pkgs, ... }:

{
  # Enable Flakes and nix-command for everyone
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System packages for all hosts
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget

    vesktop
    # add more tools here
  ];

  # Set timezone
  time.timeZone = "Europe/Vienna";

  # Example: default editor
  programs.vim.defaultEditor = true;
}
