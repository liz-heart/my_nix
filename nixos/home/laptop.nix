# nixos/home/laptop.nix
{ pkgs, ... }:

{
  home.stateVersion = "25.05";

  programs.zsh.enable = true;
  home.packages = with pkgs; [
    zsh
    neofetch
    btop
  ];
}
