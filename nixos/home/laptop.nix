{ pkgs, ... }:

let
  startupScript = pkgs.writeShellScriptBin "start" (builtins.readFile ./startup/start.sh);
in {
  home.username = "dominik";
  home.homeDirectory = "/home/dominik";
  home.stateVersion = "25.05";

  programs.zsh.enable = true;

  # bindet das Start-Skript als Autostart ein
  home.file.".config/hypr/start.sh".source = ./startup/start.sh;

  home.packages = with pkgs; [
    zsh
    neofetch
    btop
    swww
    wl-clipboard
    networkmanagerapplet
    clipman
    waybar
    dolphin               # ✅ Dateimanager wie unter Plasma
    polkit_gnome          # ✅ für Admin-Rechte in dolphin
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = [
        "~/.config/hypr/start.sh"
        "${pkgs.hyprpaper}/bin/hyprpaper &"
        "${pkgs.hyprpaper}/bin/hyprpaper wallpaper eDP-1 /home/dominik/wallpapers/w1.png"
      ];

      input = {
        kb_layout = "at";
        kb_variant = "nodeadkeys";
      };

      bind = [
        "SUPER, Return, exec, ${pkgs.kitty}/bin/kitty"
        "SUPER, D, exec, ${pkgs.wofi}/bin/wofi --show drun"
        "SUPER SHIFT, Q, killactive"
        "SUPER, F, togglefloating"
        "SUPER, Spa
