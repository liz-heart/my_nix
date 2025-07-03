{ config, pkgs, ... }:

{
  # Kein X11
  services.xserver.enable = false;

  # Hyprland aktivieren
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  # Display Manager greet
#  services.greetd = {
 #   enable = true;
  #  settings.default_session = {
   #   command = "${pkgs.hyprland}/bin/Hyprland";
    #  user = "dominik";
   # };
#  };

  # Tastatur-Layout
  services.xserver.xkb = {
    layout = "at";
    variant = "nodeadkeys";
  };

  # PipeWire Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Steam
  programs.steam.enable = true;
}
