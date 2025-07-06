{ config, pkgs, ... }:

{
  # Enable NetworkManager (recommended over traditional wireless)
  networking.networkmanager.enable = true;

  # Disable legacy wireless config (conflicts with NetworkManager)
  networking.wireless.enable = false;

  # Enable D-Bus (required by many services)
  services.dbus.enable = true;
}
