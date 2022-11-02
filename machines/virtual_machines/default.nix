{
  # TODO: build minimal image to setup deployment or build the entire image on the host with every change?
  # discover bootloader args?
  # configure via mac?
  # mount file with configuration
  # use host network and libvirt static adresses

  imports = [
    ./boot.nix
    ./partitioning.nix
    ./network.nix
    ./kubernetes.nix # FIXME: make kubernetes configurable (and optional)
  ];
}