{ pkgs, ... }:

let
  # Autostart-Skript als Shell-Binary bereitstellen
  startupScript = pkgs.writeShellScriptBin "start" (builtins.readFile ./startup/start.sh);
in {
  # Benutzerkonfiguration
  home.username = "dominik";
  home.homeDirectory = "/home/dominik";
  home.stateVersion = "25.05";

  # Zsh aktivieren
  programs.zsh.enable = true;

  # Autostart-Skript für Hyprland
  home.file.".config/hypr/start.sh".source = ./startup/start.sh;

    # Waybar-Konfiguration mit Workspace-Scroll und Icons
  home.file.".config/waybar/config.jsonc".text = builtins.readFile ./startup/waybar-config.jsonc;
  home.file.".config/waybar/style.css".text = builtins.readFile ./startup/waybar-style.css;




  # Hyprpaper-Konfiguration für Hintergrundbild (verhindert kurzes Hyprland-Standard-Wallpaper)
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = /home/dominik/my_nix/wallpapers/w1.jpg
    wallpaper = eDP-1,/home/dominik/my_nix/wallpapers/w1.jpg
    wallpaper = HDMI-A-1,/home/dominik/my_nix/wallpapers/w1.jpg
    splash = false
    ipc = off
    scaling = fill
  '';

  # System- und Benutzerprogramme
  home.packages = with pkgs; [
    # Shell & Systemtools
    zsh                    # Z-Shell
    neofetch               # Systemübersicht im Terminal
    btop                   # Ressourcenmonitor
    swww                   # (optional) Wallpaper-Tool, derzeit nicht aktiv verwendet
    wl-clipboard           # Clipboard für Wayland
    clipman                # Clipboard-Manager
    waybar                 # Statusleiste oben
    networkmanagerapplet   # WLAN/Netzwerk-Applet
    polkit_gnome           # Admin-Rechte (PolicyKit Integration)

    # KDE-Anwendungen (nützlich & bewährt)
    kdePackages.dolphin    # Datei-Manager
    kdePackages.kate       # Texteditor
    kdePackages.okular     # PDF-Viewer
    kdePackages.gwenview   # Bildbetrachter

    # Bildschirm sperren (einfach & stabil unter Wayland)
    swaylock
  ];

  # Hyprland-Fenstermanager konfigurieren
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # Monitor-Layout (Multimonitor-Setup: externer Monitor links von internem)
      monitor = [
        "HDMI-A-1,1920x1080@60,-1920x0,1.0"
        "eDP-1,1920x1080@60,0x0,1.0"
      ];

      # Programme beim Start automatisch ausführen
      exec-once = [
        "${pkgs.hyprpaper}/bin/hyprpaper &"            # Hintergrund setzen
        "sleep 0.5 && ${pkgs.waybar}/bin/waybar &"     # Statusleiste mit kurzem Delay
        "sleep 0.5 && ~/.config/hypr/start.sh"         # Benutzer-Startskript
      ];

      # Tastaturlayout für AT (Österreich)
      input = {
        kb_layout = "at";
        kb_variant = "nodeadkeys";
      };

      # Tastenkombinationen (Window- und Workspace-Management)
      bind = [
        # ▶ Programme starten
        "SUPER, Return, exec, ${pkgs.kitty}/bin/kitty"                # Terminal
        "SUPER, 1, exec, ${pkgs.wofi}/bin/wofi --show drun"           # App-Launcher
        "SUPER, 2, exec, ${pkgs.kdePackages.dolphin}/bin/dolphin"     # Dateimanager
        "SUPER, Z, exec, ${pkgs.swaylock}/bin/swaylock -f -c 000000"  # Bildschirm sperren (schwarz)

        # ▶ Fenstersteuerung
        "SUPER, X, killactive"       # Fenster schließen
        "SUPER, F, togglefloating"   # Floating-Modus umschalten
        "SUPER, Space, fullscreen"   # Vollbildmodus

        # ▶ Workspaces (im QWERTY-Block, gut erreichbar)
        "SUPER, Q, workspace, 1"
        "SUPER, W, workspace, 2"
        "SUPER, E, workspace, 3"
        "SUPER, R, workspace, 4"
        "SUPER, T, workspace, 5"

        # ▶ Fenster in andere Workspaces verschieben
        "SUPER SHIFT, Q, movetoworkspace, 1"
        "SUPER SHIFT, W, movetoworkspace, 2"
        "SUPER SHIFT, E, movetoworkspace, 3"
        "SUPER SHIFT, R, movetoworkspace, 4"
        "SUPER SHIFT, T, movetoworkspace, 5"

        # ▶ Fensterfokus (Vim-Stil)
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

      # Fenster mit der Maus verschieben und skalieren
      bindm = [
        "SUPER, mouse:272, movewindow"   # Linksklick + SUPER
        "SUPER, mouse:273, resizewindow" # Rechtsklick + SUPER
      ];
    };
  };
}
