{
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelModules = [ "kvm-amd" "kvm-intel" ];
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
