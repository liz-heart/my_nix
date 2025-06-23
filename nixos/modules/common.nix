{ config, pkgs, ... }:

{
  # Enable Flakes and nix-command for everyone
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System packages for all hosts
  environment.systemPackages = with pkgs; [
    gparted

    # tools
    unzip
    vim
    curl
    wget

    # textdocuments
    libreoffice
    onlyoffice-bin

    # bash
    # SearchEngines
    ddgr

    # notes
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

  # Set timezone
  time.timeZone = "Europe/Vienna";

  # Example: default editor
  programs.vim.defaultEditor = true;

  # Install firefox
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
      # Add-ons lassen sich hier nur verlinken über Install, oder du kopierst policies.json manuell
      Extensions = {
        Install = [
          "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
          "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-privacy-essentials/latest.xpi"
         ];
      };
    };

    };
    }
