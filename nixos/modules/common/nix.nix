# nixos/modules/common/nix.nix
{ config, pkgs, lib, ... }:

{
  # Enable modern Nix features: flakes & nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Global fonts available to all users
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  # Global system packages available to all users
  environment.systemPackages = with pkgs; [
    # Core utilities
    gparted unzip vim curl wget file

    # Office & note-taking
    libreoffice obsidian

    # CLI tools & shell
    zsh dunst fastfetch btop ddgr wl-clipboard clipman grim slurp

    # Wayland tools
    swww waybar networkmanagerapplet polkit_gnome swaylock

    # KDE/Qt applications and integration
    kdePackages.kservice
    kdePackages.kde-cli-tools
    kdePackages.dolphin
    kdePackages.kate
    kdePackages.okular
    kdePackages.gwenview
    kdePackages.kscreen
    kdePackages.plasma-systemmonitor
    kdePackages.kio
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.kio-admin
    kdePackages.qtwayland
    kdePackages.kdegraphics-thumbnailers
    kdePackages.breeze-icons
    kdePackages.qtsvg
    kdePackages.plasma-integration
    kdePackages.plasma-workspace
    shared-mime-info
    desktop-file-utils

    # Development tools
    vscode
    android-studio
    jetbrains.idea-community-bin
    gitFull

    # Communication / multimedia
    vesktop

    # Custom screenshot script
    (writeShellScriptBin "screenshot" ''
      #!/usr/bin/env bash
      FILE="/tmp/screenshot.png"
      grim -g "$(slurp)" "$FILE" &&
        cp "$FILE" ~/Pictures/Screenshots/screenshot-$(date +%s).png
    '')
  ];

  # Enable hybrid GPU drivers (Intel + AMD)
  services.xserver.videoDrivers = [ "amdgpu" "intel" ];

  # Set system timezone
  time.timeZone = "Europe/Vienna";

  # Set vim as the default editor
  programs.vim.defaultEditor = true;

  # Firefox with privacy-friendly policies
  programs.firefox = {
    enable = true;
    policies = {
      Homepage = {
        URL = "https://duckduckgo.com";
        StartPage = "homepage";
      };
      SearchEngines.Default = "DuckDuckGo";
      Extensions.Install = [
        "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
        "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-privacy-essentials/latest.xpi"
      ];
    };
  };

  # XDG portal integration (important for KDE/Wayland apps)
  xdg.menus.enable = true;
  xdg.mime.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = lib.mkForce "xdg-desktop-portal-hyprland";
}
