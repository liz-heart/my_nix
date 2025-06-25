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

  wayland.windowManager.hyprland = {
    enable = true;

    settings.exec-once = [
      "${pkgs.writeShellScriptBin "start" ''${pkgs.waybar}/bin/waybar & ${pkgs.hyprpaper}/bin/hyprpaper &''}/bin/start"
    ];
  };
}
