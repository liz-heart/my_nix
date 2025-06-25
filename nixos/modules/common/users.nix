{ config, pkgs, ... }:

{
  users.users.dominik = {
    isNormalUser = true;
    description = "dominik";
    extraGroups = [ "networkmanager" "wheel" ];
    # Home-Manager wird Flake-basiert geladen
  };

  users.users.lizheart = {
    isNormalUser = true;
    description = "lizheart";
    extraGroups = [ "networkmanager" ];
    hashedPassword = "$6$mRgYrRekRfq32eIa$9oOKii/05Xq/ozRGR.LFt8IjbJr2c8zf.BOE9lRatrv4RTwzNr2AQftNiK5sMNQ32wbh/Vrzsup1gVIkBe/zc/";
  };
}
