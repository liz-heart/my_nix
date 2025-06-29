# nixos/hosts/laptops.nix
{ config, pkgs, lib, ... }:

let
  my = {
    desktopEnvironment = "hyprland"; # oder: "plasma"
  };
in
{
  imports =
    [
      ../hardware/laptop.nix
      ../modules/common/nix.nix
      ../modules/common/users.nix
      ../modules/common/network.nix
    ]
    ++ lib.optionals (my.desktopEnvironment == "plasma") [
      ../modules/desktop/plasma.nix
    ]
    ++ lib.optionals (my.desktopEnvironment == "hyprland") [
      ../modules/desktop/hyprland.nix
      ../modules/desktop/hyprland-extras.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
