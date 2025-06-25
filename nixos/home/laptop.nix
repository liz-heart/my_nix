# nixos/home/laptop.nix
{ pkgs, ... }:

{
  home.username = "dominik";
  home.homeDirectory = "/home/dominik";
  home.stateVersion = "25.05";

  programs.zsh.enable = true;
  home.packages = with pkgs; [
    zsh
    neofetch
    btop
  ];
}
