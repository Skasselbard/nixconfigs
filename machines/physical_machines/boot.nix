{
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # loader.efi.efiSysMountPoint = "/boot/efi";
    kernelModules = [ "kvm-amd" "kvm-intel" ];
    # Setup keyfile
    # initrd.secrets = { "/crypto_keyfile.bin" = null; };
    initrd.availableKernelModules = [
      "ehci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod" # from atom autodetect
      #  "xhci_pci" "ehci_pci" # from virtualization guide
    ];
  };
}
