{ config, pkgs, ... }:

{
  # Import additional tools and services for Hyprland (e.g. greetd, keyring, waybar)
  imports = [
    ./extras.nix
  ];

  # Disable X11 completely
  services.xserver.enable = false;

  # Enable Hyprland and XWayland
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  # Keyboard layout configuration (legacy XKB-compatible tools may need this)
  services.xserver.xkb = {
    layout = "at";
    variant = "nodeadkeys";
  };

  # Enable PipeWire audio stack (recommended on Wayland)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Gaming support
  programs.steam.enable = true;
}
