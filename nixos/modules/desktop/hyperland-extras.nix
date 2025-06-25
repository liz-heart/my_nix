# nixos/modules/desktop/hyprland-extras.nix
{ pkgs, inputs, ... }:

{
  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  programs.hyprland.xwayland.enable = true;

  environment.systemPackages = with pkgs; [
    waybar
    hyprpaper
    kitty
    wofi
    wl-clipboard
    brightnessctl
    pamixer
    xdg-desktop-portal-hyprland
  ];
}
