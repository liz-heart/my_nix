# nixos/modules/common/users.nix
{ config, pkgs, ... }:

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
    hashedPasswordFile = toString ./secrets/lizheart-password.hash;
  };
}
