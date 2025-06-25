# nixos/modules/common/nix.nix
{ config, pkgs, ... }:

{
  # Flakes & nix-command aktivieren
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Standardpakete für alle Hosts
  environment.systemPackages = with pkgs; [
    gparted

    # tools
    unzip
    vim
    curl
    wget

    # text
    libreoffice
    onlyoffice-bin

    # bash & suchmaschinen
    ddgr

    # notizen
    obsidian

    # dev
    vscode
    android-studio
    jetbrains.idea-community-bin

    # git
    gitFull

    # multimedia
    vesktop
  ];

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
}
