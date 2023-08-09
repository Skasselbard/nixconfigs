{ lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.loader = {
    grub = { device = "/dev/vda"; };
    timeout = lib.mkDefault 1;
  };
}
