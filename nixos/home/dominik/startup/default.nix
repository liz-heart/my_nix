{ pkgs, ... }:

let
  startupScript = pkgs.writeShellScriptBin "start" (builtins.readFile ./start.sh);
in {
  home.packages = [ startupScript ];

  home.file.".config/hypr/start.sh" = {
    source = ./start.sh;
    executable = true;
  };
}
