{ config, pkgs, ... }:

{
  # Wayland + XWayland
  services.xserver.enable = false;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Optional: greetd als Display-Manager für Wayland
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "dominik";
      };
    };
  };

  # Keyboard Layout (für XWayland-Apps und Tools)
  services.xserver.xkb = {
    layout = "at";
    variant = "nodeadkeys";
  };

  # Audio über PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true; # Optional
  };

  # Tools & Empfehlungen
  environment.systemPackages = with pkgs; [
    waybar
    hyprpaper
    kitty
    wofi
    xdg-desktop-portal-hyprland
    wl-clipboard
    brightnessctl
    pamixer
    polkit_gnome
  ];

  # Steam optional
  programs.steam.enable = true;
}
