{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;
  networking.wireless.enable = false; # NICHT gleichzeitig aktiv
  services.dbus.enable = true;
}
