{ pkgs, config, ... }:

let
  # Startscript für Hyprland-Session
  startupScript = pkgs.writeShellScriptBin "start" (builtins.readFile ./startup/start.sh);

  # Wrapper für LibreOffice Writer zur Setzung von KDE-relevanten Umgebungsvariablen
  libreofficeWriterWrapper = pkgs.writeShellScriptBin "libreoffice-writer-wrapper" ''
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=KDE
    export KDE_FULL_SESSION=true
    exec ${pkgs.libreoffice}/bin/libreoffice --writer "$@"
  '';
in {
  imports = [
    ./startup
    ./waybar
    ./cli/bottom
  ];

  home.username = "dominik";
  home.homeDirectory = "/home/dominik";
  home.stateVersion = "25.05";

  # Setzen der XDG_DATA_DIRS für MIME- & Menü-Erkennung
  home.sessionVariables = {
    XDG_DATA_DIRS = pkgs.lib.concatStringsSep ":" [
      "${pkgs.vscode}/share"
      "${pkgs.kdePackages.okular}/share"
      "${config.home.homeDirectory}/.nix-profile/share"
      "/etc/profiles/per-user/${config.home.username}/share"
      "/run/current-system/sw/share"
      "/usr/share"
    ];
  };

  # Eigene .desktop-Dateien
  xdg.desktopEntries = {
    vscode = {
      name = "Visual Studio Code";
      exec = "${pkgs.vscode}/bin/code --no-sandbox --unity-launch %F";
      icon = "vscode";
      type = "Application";
      terminal = false;
      categories = [ "Development" "IDE" ];
      mimeType = [ "text/plain" "text/x-nix" "inode/directory" ];
    };

    libreoffice-writer = {
      name = "LibreOffice Writer";
      exec = "${libreofficeWriterWrapper}/bin/libreoffice-writer-wrapper %f";
      icon = "libreoffice-writer";
      type = "Application";
      terminal = false;
      categories = [ "Office" ];
      mimeType = [
        "application/vnd.oasis.opendocument.text"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      ];
    };

    libreoffice-calc = {
      name = "LibreOffice Calc";
      exec = "${pkgs.libreoffice}/bin/libreoffice --calc %U";
      icon = "libreoffice-calc";
      type = "Application";
      terminal = false;
      categories = [ "Office" ];
      mimeType = [
        "application/vnd.oasis.opendocument.spreadsheet"
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      ];
    };

    libreoffice-impress = {
      name = "LibreOffice Impress";
      exec = "${pkgs.libreoffice}/bin/libreoffice --impress %U";
      icon = "libreoffice-impress";
      type = "Application";
      terminal = false;
      categories = [ "Office" ];
      mimeType = [
        "application/vnd.oasis.opendocument.presentation"
        "application/vnd.openxmlformats-officedocument.presentationml.presentation"
      ];
    };
  };

  # MIME-Zuordnungen
  xdg.mime.enable = true;
  xdg.configFile."mimeapps.list".text = ''
    [Default Applications]
    application/pdf=org.kde.okular.desktop;
    text/plain=org.kde.kate.desktop;
    text/x-nix=vscode.desktop;

    application/vnd.oasis.opendocument.text=libreoffice-writer.desktop;
    application/vnd.openxmlformats-officedocument.wordprocessingml.document=libreoffice-writer.desktop;
    application/vnd.oasis.opendocument.spreadsheet=libreoffice-calc.desktop;
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet=libreoffice-calc.desktop;
    application/vnd.oasis.opendocument.presentation=libreoffice-impress.desktop;
    application/vnd.openxmlformats-officedocument.presentationml.presentation=libreoffice-impress.desktop;
  '';

  # Shell
  programs.zsh.enable = true;
  # process/system visualization and management application
  programs.bottom.enable = true;

  # Startskript für Hyprland (Tray, Clipboard, Benachrichtigungen, etc.)
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

  # Hintergrundbild-Konfiguration für hyprpaper
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = /home/dominik/my_nix/wallpapers/w1.jpg
    wallpaper = eDP-1,/home/dominik/my_nix/wallpapers/w1.jpg
    wallpaper = HDMI-A-1,/home/dominik/my_nix/wallpapers/w1.jpg
    splash = false
    ipc = off
    scaling = fill
  '';

  # Zusätzliche Pakete, aktuell leer
  home.packages = with pkgs; [ ];

  # Hyprland-Konfiguration
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
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"

        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"

        "SUPER, TAB, workspace, +1"
        "SUPER_SHIFT, TAB, workspace, -1"


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
