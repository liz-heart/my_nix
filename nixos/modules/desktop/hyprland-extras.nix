{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    waybar
    hyprpaper
    kitty
    wofi
    wl-clipboard
    brightnessctl
    pamixer
    xdg-desktop-portal-hyprland
    networkmanagerapplet  # WLAN GUI
    polkit_gnome
  ];
}
