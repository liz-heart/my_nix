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

  # Hyprpaper: Hintergrundbild setzen über Konfigurationsdatei
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = /home/dominik/my_nix/wallpapers/w1.png
    wallpaper = eDP-1,/home/dominik/my_nix/wallpapers/w1.png
  '';

  # Installierte Pakete
  home.packages = with pkgs; [
    # Terminal & Systemtools
    zsh                    # Shell
    neofetch               # Systeminfo im Terminal
    btop                   # Ressourcenmonitor (modernes htop)
    swww                   # Wallpaper-Übergänge (optional)
    wl-clipboard           # Clipboard für Wayland
    clipman                # Clipboard-Manager
    waybar                 # Statusleiste
    networkmanagerapplet   # GUI für WLAN
    polkit_gnome           # PolicyKit für Admin-Rechte
    swaylock       # Schöner Lockscreen für Hyprland

    # KDE/Qt Anwendungen
    kdePackages.dolphin    # Dateimanager (Qt6)
    kdePackages.kate       # Texteditor
    kdePackages.okular     # PDF & Dokumentenanzeige
    kdePackages.spectacle  # Screenshots
    kdePackages.gwenview   # Bildbetrachter
  ];

  # Hyprland-Konfiguration via Home-Manager
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # Automatisch gestartete Anwendungen
      exec-once = [
        "${pkgs.hyprpaper}/bin/hyprpaper &"
        "${pkgs.waybar}/bin/waybar &"
        "~/.config/hypr/start.sh"
      ];

      # Tastaturlayout
      input = {
        kb_layout = "at";
        kb_variant = "nodeadkeys";
      };

      # Tastenkürzel
      bind = [
        # ▶ Programme starten
        "SUPER, Return, exec, ${pkgs.kitty}/bin/kitty"                  # Terminal
        "SUPER, Q, exec, ${pkgs.wofi}/bin/wofi --show drun"             # App-Launcher
        "SUPER, W, exec, ${pkgs.kdePackages.dolphin}/bin/dolphin"       # Dateimanager
        "SUPER, Z, exec, ${pkgs.swaylock}/bin/swaylock --clock --indicator --grace 3 --effect-blur 7x5"  # Bildschirm sperren
        "SUPER SHIFT, S, exec, ${pkgs.kdePackages.spectacle}/bin/spectacle"  # Screenshot-Tool

        # ▶ Fenster- und Workspace-Steuerung
        "SUPER, R, killactive"               # Aktives Fenster schließen
        "SUPER, F, togglefloating"           # Floating-Modus an/aus
        "SUPER, Space, fullscreen"           # Vollbild an/aus

        # ▶ Workspaces wechseln
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"

        # ▶ Fenster in andere Workspaces verschieben
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"

        # ▶ Fokus verschieben (Vim-Stil)
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"

        # ▶ Fenster verschieben (Vim-Stil)
        "SUPER SHIFT, H, movewindow, l"
        "SUPER SHIFT, L, movewindow, r"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER SHIFT, J, movewindow, d"
      ];

      # ▶ Maus-Interaktion mit Fenstern
      bindm = [
        "SUPER, mouse:272, movewindow"   # Mit Super + Linksklick Fenster ziehen
        "SUPER, mouse:273, resizewindow" # Mit Super + Rechtsklick Fenstergröße ändern
      ];
    };
  };
}
