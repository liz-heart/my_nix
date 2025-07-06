{ pkgs, ... }:

{
  home.file.".config/waybar/config.jsonc".source = ./waybar.jsonc;
  home.file.".config/waybar/style.css".source = ./waybar.css;
}
