# nixos/modules/common/nix.nix
{ config, pkgs, ... }:

{
  # Flakes & nix-command aktivieren
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Standardpakete für alle Hosts
  environment.systemPackages = with pkgs; [
    # System-Tools
    gparted
    unzip
    vim
    curl
    wget
    file

    # Textverarbeitung & Notizen
    libreoffice
    obsidian

    # Terminal & CLI-Tools
    zsh
    dunst
    neofetch
    btop
    ddgr
    wl-clipboard
    clipman
    grim
    slurp

    # Wayland GUI-Tools
    swww
    waybar
    networkmanagerapplet
    polkit_gnome
    swaylock

    # KDE
    kdePackages.kservice
    kdePackages.kde-cli-tools
    kdePackages.dolphin
    kdePackages.kate
    kdePackages.okular
    kdePackages.gwenview
    kdePackages.kscreen
    kdePackages.plasma-systemmonitor

    # Entwicklung
    vscode
    android-studio
    jetbrains.idea-community-bin
    gitFull

    # Kommunikation / Multimedia
    vesktop

    desktop-file-utils

    # Screenshot-Skript
    (pkgs.writeShellScriptBin "screenshot" ''
      #!/usr/bin/env bash
      FILE="/tmp/screenshot.png"
      grim -g "$(slurp)" "$FILE" &&
        cp "$FILE" ~/Bilder/Bildschirmfotos/screenshot-$(date +%s).png
    '')
  ];

  services.xserver.videoDrivers = [ "amdgpu" "intel" ];

  # Zeitzone
  time.timeZone = "Europe/Vienna";

  # vim als Default-Editor
  programs.vim.defaultEditor = true;

  # Firefox inkl. Einstellungen und Erweiterungen
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

  # XDG Portal Konfiguration für .desktop-Erkennung
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "gtk";
}
