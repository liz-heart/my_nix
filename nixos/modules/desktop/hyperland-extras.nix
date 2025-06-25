{ pkgs, ... }:

{
  programs.hyprland.enable = true;
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
