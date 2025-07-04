# nixos/modules/common/nix.nix
{ config, pkgs, ... }:

{
  # Aktiviert die neuen Nix-Funktionen: Flakes & nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Globale Systempakete für alle Hosts verfügbar machen
    fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  environment.systemPackages = with pkgs; [

    # System-Tools
    gparted                    # Partitionierung & Festplattenverwaltung
    unzip                      # Entpacken von .zip-Dateien
    vim                        # Terminal-basierter Texteditor
    curl                       # HTTP-Client
    wget                       # Alternativer HTTP-Download-Client
    file                       # Dateityp-Erkennung per CLI

    # Textverarbeitung & Notizen
    libreoffice                # Office-Suite
    obsidian                   # Markdown-Notizen und Wissensdatenbank

    # Terminal & CLI-Tools
    zsh                        # Alternativer Shell
    dunst                      # Notification-Daemon
    neofetch                   # Systeminfo im Terminal anzeigen
    btop                       # Systemmonitor im Terminal (CPU, RAM, Prozesse)
    ddgr                       # DuckDuckGo über die CLI nutzen
    wl-clipboard               # Zwischenablage für Wayland
    clipman                    # Clipboard-Manager
    grim                       # Screenshot-Tool für Wayland
    slurp                      # Auswahlrechteck für Screenshots mit grim

    # Wayland GUI-Tools
    swww                       # Wallpaper-Manager für Wayland
    waybar                     # Statusleiste für Wayland (Hyprland, Sway)
    networkmanagerapplet       # GUI für Netzwerkeinstellungen
    polkit_gnome               # PolicyKit Agent für Authentifizierungen
    swaylock                   # Bildschirmsperre für Wayland

    # KDE-Komponenten (für Dolphin & Co. wichtig, auch unter Hyprland)
    kdePackages.kservice                         # KDE Service-Infrastruktur (wichtig für kbuildsycoca6)
    kdePackages.kde-cli-tools                    # Enthält Tools wie kbuildsycoca6
    kdePackages.dolphin                          # KDE-Dateimanager
    kdePackages.kate                             # KDE Texteditor
    kdePackages.okular                           # PDF-Viewer
    kdePackages.gwenview                         # Bildbetrachter
    kdePackages.kscreen                          # Bildschirm-Einstellungen
    kdePackages.plasma-systemmonitor             # Systemmonitor mit GUI
    kdePackages.kio                              # Datei-IO-Backend
    kdePackages.kio-fuse                         # KIO über FUSE (z. B. Netzwerkzugriffe)
    kdePackages.kio-extras                       # Zusätzliche Protokolle wie smb://
    kdePackages.kio-admin                        # Root-Rechte für Dateiaktionen
    kdePackages.qtwayland                        # Wayland-Support für Qt/KDE-Apps
    kdePackages.kdegraphics-thumbnailers         # Vorschaugeneratoren (z. B. für Bilder)
    kdePackages.breeze-icons                     # KDE Icon-Theme
    kdePackages.qtsvg                            # SVG-Support für Icons
    kdePackages.plasma-integration               # KDE-Integration für Qt-Anwendungen
    kdePackages.plasma-workspace                 # Enthält plasma-applications.menu (essentiell für Dolphin)
    shared-mime-info                             # Datenbank für MIME-Typen
    desktop-file-utils                           # Tools zum Verwalten von .desktop-Dateien

    # Entwicklung
    vscode                       # Visual Studio Code
    android-studio               # Android-IDE
    jetbrains.idea-community-bin # IntelliJ IDEA Community Edition
    gitFull                      # Vollständige Git-Installation

    # Kommunikation / Multimedia
    vesktop                      # Discord-Client (basierend auf Vencord)

    # Eigene Skripte
    (pkgs.writeShellScriptBin "screenshot" ''
      #!/usr/bin/env bash
      FILE="/tmp/screenshot.png"
      grim -g "$(slurp)" "$FILE" &&
        cp "$FILE" ~/Bilder/Bildschirmfotos/screenshot-$(date +%s).png
    '')
  ];

  # GPU-Treiber für hybrides Setup (Intel + AMD GPU)
  services.xserver.videoDrivers = [ "amdgpu" "intel" ];

  # Zeitzone
  time.timeZone = "Europe/Vienna";

  # vim als Standard-Editor
  programs.vim.defaultEditor = true;

  # Firefox mit vorkonfiguriertem Datenschutz
  programs.firefox = {
    enable = true;
    policies = {
      Homepage = {
        URL = "https://duckduckgo.com";
        StartPage = "homepage";
      };
      SearchEngines = {
        Default = "DuckDuckGo";
      };
      Extensions = {
        Install = [
          "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
          "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-privacy-essentials/latest.xpi"
        ];
      };
    };
  };

  # XDG-Integration: sorgt dafür, dass Dolphin und KDE-Apps MIME-Types und .desktop-Dateien erkennen
  xdg.menus.enable = true;                   # Aktiviert Menüstruktur wie applications.menu
  xdg.mime.enable = true;                    # Aktiviert MIME-Typ-Zuordnung
  xdg.portal.enable = true;                  # Ermöglicht Portalintegration (z. B. Datei-Dialoge)
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "gtk"; # GTK als Standard-Backend
}
