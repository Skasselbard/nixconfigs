{
  fileSystems."/".device = "/dev/disk/by-label/nixos";
  fileSystems."/etc/nixos/hive".device = "/dev/vdb1";
  fileSystems."/etc/nixos/hive/self" = {
    device = "/dev/vdc1";
    fsType = "vfat";
    depends = [ "etc/nixos" ];
    options = [ "ro" "nofail" ];
  };
}
