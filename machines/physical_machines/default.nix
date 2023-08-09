{ ... }:
let
  nixos_libvirt =
    builtins.fetchGit { url = "https://github.com/Skasselbard/NixOs-Libvirt"; };
in { imports = [ nixos_libvirt.outPath ./boot.nix ]; }
