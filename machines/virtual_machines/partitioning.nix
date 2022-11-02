{
  fileSystems."/".device = "/dev/disk/by-label/nixos";
  fileSystems."/etc/nixos".device = "/dev/vdb1";
  fileSystems."/etc/nixos/hosts/self" = {
    device = "/dev/vdc1";
    fsType = "vfat";
    depends = ["etc/nixos"];
    options = [ "ro" "nofail" ];
  };
  fileSystems."/root/.ssh" = {
    device = "/dev/vdd1";
    fsType = "vfat";
    options = [ "ro" "nofail" ];
  };
}