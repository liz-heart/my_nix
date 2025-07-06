# nixos/modules/common/users.nix
{ config, pkgs, ... }:
# Systemnutzer
{

  users.users.dominik = {
    isNormalUser = true;
    description = "dominik";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  users.users.lizheart = {
    isNormalUser = true;
    description = "lizheart";
    extraGroups = [ "networkmanager" ];
    hashedPasswordFile = "${./secrets/lizheart-password.hash}";

  };
}
