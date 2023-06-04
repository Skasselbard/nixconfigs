{ pkgs ? import (import ./nixpkgs.nix) { } }:
let
  # Stage_0
  #####################
  create_image = pkgs.writeShellScriptBin "create_image" ''
    nixos-generate --format iso --configuration ./Stage_0/iso_config.nix -o nixos # --show-trace
  '';
  create_boot_stick = pkgs.writeShellScriptBin "create_boot_stick"
    (builtins.readFile ./Stage_0/create_boot_stick.sh);
  
  # Stage 1
  #######################
  build = pkgs.writeShellScriptBin "build" ''
    export NIX_CONFIG="tarball-ttl = 0"
    colmena build -f ./hive/hive.nix
  '';
  deploy = pkgs.writeShellScriptBin "deploy" ''
    export NIX_CONFIG="tarball-ttl = 0"
    colmena apply -f ./hive/hive.nix
  '';

in pkgs.mkShell {
  buildInputs = with pkgs; [
    # software for deployment
    colmena
    nixos-generators
    # scripts
    create_image
    create_boot_stick
    build
    deploy
  ];
}
