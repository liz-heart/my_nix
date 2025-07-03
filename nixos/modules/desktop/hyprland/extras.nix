{ pkgs, ... }:

{
  # 🖥️ Display Manager: greetd mit tuigreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Tuigreet mit Hyprland starten
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
      };
    };
  };

  # 🔐 Keyring für WLAN & andere Passwörter (automatisches Entsperren)
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # 📦 Zusätzliche Tools für Hyprland (Wayland)
  environment.systemPackages = with pkgs; [
    swaylock-effects
    waybar                    # Leiste
    hyprpaper                 # Wallpaper
    kitty                     # Terminal
    wofi                      # App-Launcher
    wl-clipboard              # Clipboard Tool
    brightnessctl             # Bildschirmhelligkeit
    pamixer                   # Audio (Lautstärke)
    xdg-desktop-portal-hyprland  # Portale für Flatpak etc.
    networkmanagerapplet      # WLAN GUI
    polkit_gnome              # GUI für Admin-Rechte
    seahorse                  # GUI für Keyring
  ];

  # 🔧 Empfohlen für GTK-Programme mit Rootrechten
  xdg.portal.enable = true;
}
