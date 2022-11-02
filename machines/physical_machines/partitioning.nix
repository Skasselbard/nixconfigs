{ lib, config, ... }:
with lib;
{
  options = {
    boot-uuid = mkOption{type = types.str;};
    root-uuid = mkOption{type = types.str;};
  };
  # The partitioning has to be done manually first (e.g. with pated)
  config.fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/${config.boot-uuid}";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-uuid/${config.root-uuid}";
      fsType = "ext4";
      autoResize = true; # grow if partition grows
    };
  };
}