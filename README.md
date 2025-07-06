# NixOS Flake Setup

## Struktur

- `nixos/hosts/` – Host-spezifische Systemkonfigurationen (z. B. `laptop.nix`)
- `nixos/hardware/` – Hardware-Profile für bestimmte Geräte
- `nixos/modules/` – Wiederverwendbare Systemmodule
  - `common/` – Allgemeine Konfiguration (Netzwerk, Benutzer, Nix, etc.)
  - `desktop/` – Desktop-Umgebungen (Hyprland, Plasma, Extras)
- `nixos/home/` – Home-Manager Konfigurationen pro Benutzer
  - `modules/` – Benutzerdefinierte Module (z. B. Waybar, Startup-Skripte)
- `wallpapers/` – Hintergrundbilder für Desktop-Setups
