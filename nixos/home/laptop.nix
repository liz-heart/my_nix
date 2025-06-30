{ pkgs, ... }:

let
  startupScript = pkgs.writeShellScriptBin "start" (builtins.readFile ./startup/start.sh);
in {
  home.username = "dominik";
  home.homeDirectory = "/home/dominik";
  home.stateVersion = "25.05";

  programs.zsh.enable = true;

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
    kdePackages.spectacle
    kdePackages.okular
    kdePackages.kate
    kdePackages.dolphin
    polkit_gnome
    swaylock-effects
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = [
        "${pkgs.waybar}/bin/waybar &"
        "${pkgs.hyprpaper}/bin/hyprpaper &"
        "${pkgs.hyprpaper}/bin/hyprpaper wallpaper eDP-1 /home/dominik/wallpapers/w1.png"
        "~/.config/hypr/start.sh"
      ];

      input = {
        kb_layout = "at";
        kb_variant = "nodeadkeys";
      };

      bind = [
        # Anwendungen
        "SUPER, Return, exec, ${pkgs.kitty}/bin/kitty"
        "SUPER, Q, exec, ${pkgs.wofi}/bin/wofi --show drun"
        "SUPER, R, killactive"
        "SUPER, F, togglefloating"
        "SUPER, Space, fullscreen"
        "SUPER, W, exec, ${pkgs.kdePackages.dolphin}/bin/dolphin"
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER, L, exec, ${pkgs.swaylock-effects}/bin/swaylock-effects --clock --indicator --grace 3 --effect-blur 7x5"
        "SUPER SHIFT, S, exec, ${pkgs.kdePackages.spectacle}/bin/spectacle"

        # Fokus verschieben (Vim-Style)
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"

        # Fenster verschieben (Vim-Style)
        "SUPER SHIFT, H, movewindow, l"
        "SUPER SHIFT, L, movewindow, r"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER SHIFT, J, movewindow, d"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"    # Linksklick
        "SUPER, mouse:273, resizewindow"  # Rechtsklick
      ];
    };
  };
}
