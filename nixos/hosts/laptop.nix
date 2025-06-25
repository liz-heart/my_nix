{ config, pkgs, ... }:
# host-spezifische Systemkonfiguration -
# Kernel, Bootloader, Netzwerk, Zeit, DE, Nutzergruppen, Hardware
{
  imports = [
    ../hardware/laptop.nix           # Hardware-Config von nixos-generate-config
    ../modules/common/nix.nix        # Nix & Flakes
    ../modules/common/users.nix      # Benutzer: dominik, lizheart
    ../modules/desktop/plasma.nix    # Desktop-Umgebung: KDE Plasma
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.extraEntries = {
    "windows.conf" = ''
      title Windows
      efi /EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Vienna";

  i18n.defaultLocale = "de_AT.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  # Nix Flakes & unfreie Software aktivieren
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Systemversion für persistente Daten
  system.stateVersion = "25.05";
}
