{ pkgs, ... }:

let
  # Autostart-Skript als Shell-Binary bereitstellen
  startupScript = pkgs.writeShellScriptBin "start" (builtins.readFile ./startup/start.sh);
in {
  # Benutzerkonfiguration
  home.username = "dominik";
  home.homeDirectory = "/home/dominik";
  home.stateVersion = "25.05";

  # XDG-Umgebungsvariable für zusätzliche .desktop-Erkennung
  home.sessionVariables = {
    XDG_DATA_DIRS = "${pkgs.lib.makeSearchPath "share" [
      pkgs.libreoffice
      pkgs.vscode
      pkgs.kdePackages.okular
    ]}:/usr/share";
  };

  # .desktop-Dateien manuell definieren für Anwendungen, die standardmäßig keine installieren
  home.file.".local/share/applications/libreoffice-writer.desktop".text = ''
    [Desktop Entry]
    Name=LibreOffice Writer
    Exec=${pkgs.libreoffice}/bin/libreoffice --writer %U
    Icon=libreoffice-writer
    Type=Application
    Categories=Office;
    MimeType=application/vnd.oasis.opendocument.text;application/vnd.openxmlformats-officedocument.wordprocessingml.document;
  '';

  home.file.".local/share/applications/libreoffice-calc.desktop".text = ''
    [Desktop Entry]
    Name=LibreOffice Calc
    Exec=${pkgs.libreoffice}/bin/libreoffice --calc %U
    Icon=libreoffice-calc
    Type=Application
    Categories=Office;
    MimeType=application/vnd.oasis.opendocument.spreadsheet;application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;
  '';

  home.file.".local/share/applications/libreoffice-impress.desktop".text = ''
    [Desktop Entry]
    Name=LibreOffice Impress
    Exec=${pkgs.libreoffice}/bin/libreoffice --impress %U
    Icon=libreoffice-impress
    Type=Application
    Categories=Office;
    MimeType=application/vnd.oasis.opendocument.presentation;application/vnd.openxmlformats-officedocument.presentationml.presentation;
  '';

  home.file.".local/share/applications/vscode.desktop".text = ''
    [Desktop Entry]
    Name=Visual Studio Code
    Exec=${pkgs.vscode}/bin/code --no-sandbox --unity-launch %F
    Icon=code
    Type=Application
    Categories=Development;IDE;
    MimeType=text/plain;text/x-nix;inode/directory;
  '';

  # Standardanwendungen für bestimmte MIME-Typen setzen
  xdg.mime.enable = true;
  xdg.configFile."mimeapps.list".text = ''
    [Default Applications]
    application/pdf=org.kde.okular.desktop;
    text/plain=org.kde.kate.desktop;
    application/vnd.oasis.opendocument.text=libreoffice-writer.desktop;
    application/vnd.openxmlformats-officedocument.wordprocessingml.document=libreoffice-writer.desktop;
    application/vnd.oasis.opendocument.spreadsheet=libreoffice-calc.desktop;
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet=libreoffice-calc.desktop;
    application/vnd.oasis.opendocument.presentation=libreoffice-impress.desktop;
    application/vnd.openxmlformats-officedocument.presentationml.presentation=libreoffice-impress.desktop;
    text/x-nix=vscode.desktop;
  '';

  # Beispiel-App-Eintrag (kann entfernt werden)
  xdg.desktopEntries = {
    my-app = {
      name = "My App";
      exec = "my-app-command";
      icon = "my-app-icon";
      comment = "Beschreibung";
      terminal = false;
      categories = [ "Utility" ];
    };
  };

  # Zsh aktivieren
  programs.zsh.enable = true;

  # Autostart-Skript für Hyprland (direkt eingebettet)
  home.file.".config/hypr/start.sh" = {
    text = ''
      #!/usr/bin/env bash
      nm-applet &
      wl-paste --watch clipman store &
      pgrep -x dunst > /dev/null || dunst &
      sleep 0.5
      export XDG_DATA_DIRS="${"$"}{XDG_DATA_DIRS:-${"$"}{HOME}/.nix-profile/share:/etc/profiles/per-user/${"$"}USER/share:/run/current-system/sw/share:/usr/share}"
    '';
    executable = true;
  };

  # Hyprpaper-Konfiguration für Hintergrundbild
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = /home/dominik/my_nix/wallpapers/w1.jpg
    wallpaper = eDP-1,/home/dominik/my_nix/wallpapers/w1.jpg
    wallpaper = HDMI-A-1,/home/dominik/my_nix/wallpapers/w1.jpg
    splash = false
    ipc = off
    scaling = fill
  '';

  # System- und Benutzerprogramme
  home.packages = with pkgs; [
    dunst
    zsh
    neofetch
    btop
    swww
    wl-clipboard
    clipman
    waybar
    networkmanagerapplet
    polkit_gnome
    grim
    slurp
    kdePackages.dolphin
    kdePackages.kate
    kdePackages.okular
    kdePackages.gwenview
    swaylock
    (pkgs.writeShellScriptBin "screenshot" ''
      #!/usr/bin/env bash
      FILE="/tmp/screenshot.png"
      grim -g "$(slurp)" "$FILE" &&
        cp "$FILE" ~/Bilder/Bildschirmfotos/screenshot-$(date +%s).png
    '')
  ];

  # Hyprland-Fenstermanager konfigurieren
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "HDMI-A-1,1920x1080@60,-1920x0,1.0"
        "eDP-1,1920x1080@60,0x0,1.0"
      ];
      exec-once = [
        "${pkgs.hyprpaper}/bin/hyprpaper &"
        "sleep 0.5 && ${pkgs.waybar}/bin/waybar &"
        "sleep 0.5 && ~/.config/hypr/start.sh"
      ];
      input = {
        kb_layout = "at";
        kb_variant = "nodeadkeys";
      };
      bind = [
        "SUPER, Return, exec, ${pkgs.kitty}/bin/kitty"
        "SUPER, Q, exec, ${pkgs.wofi}/bin/wofi --show drun"
        "SUPER, W, exec, ${pkgs.kdePackages.dolphin}/bin/dolphin"
        "SUPER, Z, exec, ${pkgs.swaylock}/bin/swaylock -f -c 000000"
        "SUPER_SHIFT, S, exec, screenshot"
        "SUPER_ALT, S, exec, ${pkgs.kdePackages.dolphin}/bin/dolphin /home/dominik/Bilder/Bildschirmfotos"
        "SUPER, X, killactive"
        "SUPER, F, togglefloating"
        "SUPER, Space, fullscreen"
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"
        "SUPER SHIFT, H, movewindow, l"
        "SUPER SHIFT, L, movewindow, r"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER SHIFT, J, movewindow, d"
      ];
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };
}
