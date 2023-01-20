{ ... }:
let
  nixos_libvirt =
    builtins.fetchGit { url = "https://github.com/Skasselbard/NixOs-Libvirt"; };
in {
  imports = [
    ../default.nix
    nixos_libvirt.outPath
    ./boot.nix
    ./partitioning.nix
    ./network.nix
  ];
}
