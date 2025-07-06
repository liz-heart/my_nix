{ config, pkgs, lib, ... }:

{
  # Home Manager activation
  home.username = "lizheart";
  home.homeDirectory = "/home/lizheart";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Basic shell config
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -la";
      gs = "git status";
    };
  };

  # Set ZSH as default shell
  home.shell = pkgs.zsh;

  # GTK / Plasma theming
  gtk = {
    enable = true;
    theme.name = "Breeze";
    iconTheme.name = "breeze";
  };

  # Qt theming (KDE / Plasma)
  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "Breeze";
  };

  # Set fonts (adjust as needed)
  fonts.fontconfig.enable = true;

  # Wallpaper handling (optional)
  home.file.".config/plasma-org.kde.plasma.desktop-appletsrc".text = ''
    # KDE Plasma desktop layout config (optional placeholder)
  '';

  # VSCode config (optional)
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-vscode.vscode-typescript-next
    ];
  };

  # Final activation
  home.stateVersion = "25.05";
}
