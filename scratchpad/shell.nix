{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.terraform
    pkgs.awscli2
  ];
}
