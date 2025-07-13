{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.libvirtd = {
    enable = true;
    # enable tpm and secure boot for windows VMs https://www.debugpoint.com/install-windows-ubuntu-virt-manager/
    qemu.swtpm.enable = true;
    qemu.ovmf.enable = true;
  };
}
