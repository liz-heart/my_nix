{ pkgs, ... }:

let
  # Autostart-Skript als ausführbares Binary verfügbar machen
  startupScript = pkgs.writeShellScriptBin "start" (builtins.readFile ./startup/start.sh);
in {
  # Benutzerkonfiguration
  home.username = "dominik";
  home.homeDirectory = "/home/dominik";
  home.stateVersion = "25.05";

  # Zsh aktivieren
  programs.zsh.enable = true;

  # Autostart-Skript beim Hyprland-Start einbinden
  home.file.".config/hypr/start.sh".source = ./startup/start.sh;

  # Hintergrundbild setzen über Hyprpaper (Home-Manager verwaltet Konfig)
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = /home/dominik/my_nix/wallpapers/w1.png
    wallpaper = eDP-1,/home/dominik/my_nix/wallpapers/w1.png
  '';

  # Installierte Programme
  home.packages = with pkgs; [
    # Shell & Tools
    zsh
    neofetch
    btop
    swww
    wl-clipboard
    clipman
    waybar
    networkmanagerapplet
    polkit_gnome

    # KDE-Anwendungen
    kdePackages.dolphin    # Dateimanager
    kdePackages.kate       # Texteditor
    kdePackages.okular     # PDF-Betrachter
    kdePackages.spectacle  # Screenshots
    kdePackages.gwenview   # Bilder anzeigen

    # Bildschirm sperren (klassisch, stabil)
    swaylock
  ];

  # Hyprland-Konfiguration
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = [
        "${pkgs.hyprpaper}/bin/hyprpaper &"
        "${pkgs.waybar}/bin/waybar &"
        "~/.config/hypr/start.sh"
      ];

      input = {
        kb_layout = "at";
        kb_variant = "nodeadkeys";
      };

      bind = [
        # Programme starten
        "SUPER, Return, exec, ${pkgs.kitty}/bin/kitty"
        "SUPER, Q, exec, ${pkgs.wofi}/bin/wofi --show drun"
        "SUPER, W, exec, ${pkgs.kdePackages.dolphin}/bin/dolphin"
        "SUPER, Z, exec, ${pkgs.swaylock}/bin/swaylock -f -c 000000"
        "SUPER SHIFT, S, exec, ${pkgs.kdePackages.spectacle}/bin/spectacle"

        # Fenstersteuerung
        "SUPER, R, killactive"
        "SUPER, F, togglefloating"
        "SUPER, Space, fullscreen"

        # Workspaces wechseln
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"

        # Fenster in andere Workspaces verschieben
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"

        # Fokus verschieben (Vim-Stil)
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"

        # Fenster verschieben
        "SUPER SHIFT, H, movewindow, l"
        "SUPER SHIFT, L, movewindow, r"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER SHIFT, J, movewindow, d"
      ];

      # Fenster bewegen / skalieren mit Maus
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };
}
