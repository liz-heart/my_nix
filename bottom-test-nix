# bottom-test.nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "bottom";
  version = "0.11.0";

  src = pkgs.fetchFromGitHub {
    owner = "ClementTsang";
    repo = "bottom";
    rev = "v${version}";
    sha256 = "sha256-wyuwUTKQql3G7sHaQULBRDvWc9HzUGgt7ifphYDF79c=";
  };

  cargoSha256 = "0000000000000000000000000000000000000000000000000000";

  doCheck = false;
}
