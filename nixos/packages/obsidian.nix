{ pkgs ? import <nixpkgs> {} }:

let
  inherit (pkgs) stdenv appimageTools fetchurl gtk3 gsettings-desktop-schemas git;
  version = "1.5.12";
  pname = "obsidian";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/Obsidian-${version}.AppImage";
    sha256 = "sha256-XW+N6S6CIuUoSUIRm0OxiM4z6xCo8EmUdZjvhNKtJDQ=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in appimageTools.wrapType2 rec {
  inherit name src;

  profile = ''
    export PATH=${git}/bin:$PATH
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    install -m 444 -D ${appimageContents}/obsidian.desktop $out/share/applications/obsidian.desktop
    install -m 444 -D ${appimageContents}/obsidian.png $out/share/icons/hicolor/512x512/apps/obsidian.png
    substituteInPlace $out/share/applications/obsidian.desktop --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with stdenv.lib; {
    description = "Obsidian.md AppImage with Git plugin support";
    homepage = "https://obsidian.md";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
