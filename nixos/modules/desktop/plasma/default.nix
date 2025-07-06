{ config, pkgs, ... }:

{
  # Enable X11
  services.xserver.enable = true;

  # Use SDDM as display manager
  services.displayManager.sddm.enable = true;

  # Enable KDE Plasma 6 desktop
  services.desktopManager.plasma6.enable = true;

  # Keyboard layout: Austrian with nodeadkeys
  services.xserver.xkb = {
    layout = "at";
    variant = "nodeadkeys";
  };

  # Enable CUPS printing
  services.printing.enable = true;

  # PipeWire audio setup
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true; # optional
  };

  # Enable Steam gaming support
  programs.steam.enable = true;

  # Optional: Touchpad support (libinput)
  # services.xserver.libinput.enable = true;
}
