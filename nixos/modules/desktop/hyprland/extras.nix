{ pkgs, ... }:

{
  # 🖥️ Display Manager: greetd with tuigreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
#        user = "greeter";  # Optional: run as user 'greeter' or define another one
      };
    };
  };

  # 🔐 GNOME Keyring support (e.g. for Wi-Fi passwords)
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # 📦 Recommended packages for a Hyprland Wayland setup
  environment.systemPackages = with pkgs; [
    swaylock-effects               # Lock screen
    waybar                         # Top bar
    hyprpaper                      # Wallpaper daemon
    kitty                          # Terminal emulator
    wofi                           # Application launcher
    wl-clipboard                   # Clipboard integration
    brightnessctl                  # Backlight control
    pamixer                        # Audio control (volume)
    networkmanagerapplet          # Network GUI
    seahorse                       # GNOME Keyring GUI
    polkit_gnome                  # Auth agent GUI for polkit
    xdg-desktop-portal-hyprland   # Portal interface for flatpak etc.
  ];

  # 🛠️ Required for portal integration (e.g. file picker, screencast)
  xdg.portal = {
    enable = true;
    config.common.default = "xdg-desktop-portal-hyprland";
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
