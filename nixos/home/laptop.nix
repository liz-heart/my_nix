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
    settings.exec-once = [
      "${startupScript}/bin/start"
    ];
  };
}
