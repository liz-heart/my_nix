{ config, pkgs, ... }:

{
  # X11 aktivieren
  services.xserver.enable = true;

  # SDDM als Display-Manager
  services.displayManager.sddm.enable = true;

  # KDE Plasma 6 Desktop
  services.desktopManager.plasma6.enable = true;

  # Tastatur-Layout (AT, nodeadkeys)
  services.xserver.xkb = {
    layout = "at";
    variant = "nodeadkeys";
  };

  # Drucken via CUPS
  services.printing.enable = true;

  # Audio via PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Optional: JACK
    # jack.enable = true;
  };

  # Steam aktivieren
  programs.steam.enable = true;

  # Optional: Touchpad aktivieren (falls nötig)
  # services.xserver.libinput.enable = true;
}
