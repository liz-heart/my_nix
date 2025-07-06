{ pkgs, ... }: {
  home.packages = with pkgs; [
    obsidian
    libreoffice
    vesktop
    vscode
    android-studio
    jetbrains.idea-community-bin
  ];
}
