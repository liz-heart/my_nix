{ pkgs, ... }:

let
  # Autostart-Skript als Shell-Binary bereitstellen
  startupScript = pkgs.writeShellScriptBin "start" (builtins.readFile ./startup/start.sh);
in {
  # Benutzerkonfiguration
  home.username = "dominik";
  home.homeDirectory = "/home/dominik";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    XDG_DATA_DIRS = "${pkgs.lib.makeSearchPath "share" [
      pkgs.libreoffice
      pkgs.vscode
      pkgs.kdePackages.okular
    ]}:/usr/share";
  };

  xdg.mime.enable = true;
  xdg.desktopEntries = {
    my-app = {
      name = "My App";
      exec = "my-app-command";
      icon = "my-app-icon";
      comment = "Beschreibung";
      terminal = false;
      categories = [ "Utility" ];
    };
  };
  xdg.configFile."mimeapps.list".text = ''
  [Default Applications]
  application/pdf=org.kde.okular.desktop;
  text/plain=org.kde.kate.desktop;

  # LibreOffice Writer
  application/vnd.oasis.opendocument.text=libreoffice-writer.desktop;
  application/vnd.openxmlformats-officedocument.wordprocessingml.document=libreoffice-writer.desktop;

  # LibreOffice Calc
  application/vnd.oasis.opendocument.spreadsheet=libreoffice-calc.desktop;
  application/vnd.openxmlformats-officedocument.spreadsheetml.sheet=libreoffice-calc.desktop;

  # LibreOffice Impress
  application/vnd.oasis.opendocument.presentation=libreoffice-impress.desktop;
  application/vnd.openxmlformats-officedocument.presentationml.presentation=libreoffice-impress.desktop;
  '';


  # Zsh aktivieren
  programs.zsh.enable = true;

  # Autostart-Skript für Hyprland (direkt eingebettet)
    home.file.".config/hypr/start.sh" = {
  text = ''
    #!/usr/bin/env bash

    # WLAN-Applet (GUI)
    nm-applet &

    # Clipboard-Manager
    wl-paste --watch clipman store &

    # Notification-Dienst (nur wenn nicht aktiv)
    pgrep -x dunst > /dev/null || dunst &

    # Kurzes Delay für stabile Monitor-Erkennung
    sleep 0.5

    # XDG_DATA_DIRS für .desktop-Erkennung
    export XDG_DATA_DIRS="${"$"}{XDG_DATA_DIRS:-${"$"}{HOME}/.nix-profile/share:/etc/profiles/per-user/${"$"}USER/share:/run/current-system/sw/share:/usr/share}"
  '';
  executable = true;
};




  # Waybar-Konfiguration mit Workspace-Scroll und Icons
  # home.file.".config/waybar/config.jsonc".text = builtins.readFile ./startup/waybar-config.jsonc;
  # home.file.".config/waybar/style.css".text = builtins.readFile ./startup/waybar-style.css;

  # Hyprpaper-Konfiguration für Hintergrundbild (verhindert kurzes Hyprland-Standard-Wallpaper)
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = /home/dominik/my_nix/wallpapers/w1.jpg
    wallpaper = eDP-1,/home/dominik/my_nix/wallpapers/w1.jpg
    wallpaper = HDMI-A-1,/home/dominik/my_nix/wallpapers/w1.jpg
    splash = false
    ipc = off
    scaling = fill
  '';

  home.file.".config/hypr/screenshot.sh" = {
    source = ./scripts/screenshot.sh;
    executable = true;
  };


  # System- und Benutzerprogramme
  home.packages = with pkgs; [
    # Shell & Systemtools
    dunst
    zsh
    neofetch
    btop
    swww
    wl-clipboard
    clipman
    waybar
    networkmanagerapplet
    polkit_gnome

    # Screenshot
    grim
    slurp
    wl-clipboard
    # KDE-Anwendungen (nützlich & bewährt)
    kdePackages.dolphin
    kdePackages.kate
    kdePackages.okular
    kdePackages.gwenview

    # Bildschirm sperren (einfach & stabil unter Wayland)
    swaylock

    (pkgs.writeShellScriptBin "screenshot" ''
    #!/usr/bin/env bash
    FILE="/tmp/screenshot.png"
    grim -g "$(slurp)" "$FILE" &&
      cp "$FILE" ~/Bilder/Bildschirmfotos/screenshot-$(date +%s).png
  '')
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
        "${pkgs.hyprpaper}/bin/hyprpaper &"
        "sleep 0.5 && ${pkgs.waybar}/bin/waybar &"
        "sleep 0.5 && ~/.config/hypr/start.sh"
      ];

      # Tastaturlayout für AT (Österreich)
      input = {
        kb_layout = "at";
        kb_variant = "nodeadkeys";
      };

      # Tastenkombinationen (Window- und Workspace-Management)
      bind = [
        # ▶ Programme starten
        "SUPER, Return, exec, ${pkgs.kitty}/bin/kitty"
        "SUPER, Q, exec, ${pkgs.wofi}/bin/wofi --show drun"
        "SUPER, W, exec, ${pkgs.kdePackages.dolphin}/bin/dolphin"
        "SUPER, Z, exec, ${pkgs.swaylock}/bin/swaylock -f -c 000000"
        "SUPER_SHIFT, S, exec, screenshot"
        "SUPER_ALT, S, exec, ${pkgs.kdePackages.dolphin}/bin/dolphin /home/dominik/Bilder/Bildschirmfotos"


        # ▶ Fenstersteuerung
        "SUPER, X, killactive"
        "SUPER, F, togglefloating"
        "SUPER, Space, fullscreen"

        # ▶ Workspaces (im QWERTY-Block, gut erreichbar)
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
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };
}
