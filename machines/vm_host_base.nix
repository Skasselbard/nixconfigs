{ pkgs, ... }: {
  imports = [
    # includes can not contain device specific options
    ./virtual_machines/partitioning.nix
    ./virtual_machines/boot.nix
    ../default.nix
  ];
}
