{ pkgs, ... }:

let
  startupScript = pkgs.writeShellScriptBin "start" (builtins.readFile ./startup/start.sh);
in {
  home.username = "dominik";
  home.homeDirectory = "/home/dominik";
  home.stateVersion = "25.05";

  programs.zsh.enable = true;

  home.packages = with pkgs; [
    zsh
    neofetch
    btop
    swww
    wl-clipboard
    networkmanagerapplet
    clipman
    waybar
  ];

  wayland.windowManager.hyprland = {
  enable = true;
  settings = {
    exec-once = [
      "${pkgs.waybar}/bin/waybar &"
      "${pkgs.hyprpaper}/bin/hyprpaper &"
      "${pkgs.hyprpaper}/bin/hyprpaper wallpaper eDP-1 /home/dominik/wallpapers/w1.png"
    ];

    bind = [
      "SUPER, Return, exec, ${pkgs.kitty}/bin/kitty"         # Terminal
      "SUPER, D, exec, ${pkgs.wofi}/bin/wofi --show drun"    # App-Launcher
      "SUPER SHIFT, Q, killactive"                           # Fenster schließen
      "SUPER, F, togglefloating"                             # Floating-Toggle
      "SUPER, Space, togglefullscreen"                       # Vollbild
      "SUPER, T, exec, ${pkgs.firefox}/bin/firefox"          # Firefox starten
    ];
  };
};

}
