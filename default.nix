{ ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/minimal.nix>
    ./users
    ./packages
    ./locale.nix
  ];

  # Clean /tmp on boot.
  boot.cleanTmpDir = true;

  # Automatically optimize the Nix store to save space
  # by hard-linking identical files together. These savings
  # add up.
  nix.autoOptimiseStore = true;

  # Limit the systemd journal to 100 MB of disk or the
  # last 7 days of logs, whichever happens first.
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=7day
  '';

  # system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = true;
  # system.autoUpgrade.channel = https://nixos.org/channels/nixos-21.05;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.11"; # Did you read the comment?
}
