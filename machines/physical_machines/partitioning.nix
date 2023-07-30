{ lib, config, ... }:
with lib; {
  options = {
    boot-label = mkOption {
      type = types.str;
      default = "boot";
    };
    root-label = mkOption {
      type = types.str;
      default = "nixos";
    };
  };
  # The partitioning has to be done manually first (e.g. with pated)
  config.fileSystems = lib.mkDefault {
    "/boot" = {
      device = "/dev/disk/by-label/${config.boot-label}";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/${config.root-label}";
      fsType = "ext4";
      autoResize = true; # grow if partition grows
    };
  };
}
