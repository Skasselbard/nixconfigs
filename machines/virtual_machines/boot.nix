{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.loader = {
    grub = {
      version = 2;
      device = "/dev/vda";
    };
    timeout = lib.mkDefault 0;
  };
  boot.initrd.availableKernelModules =
    [ 
      "ata_piix" 
      "uhci_hcd" 
      "sr_mod"
  #   "xhci_pci" 
  #   "ehci_pci" 
  #   "ahci" 
  #   "usbhid" 
  #   "usb_storage" 
      ];
}
