{ ... }:

{
  imports = [ ./packages ./users ./locale.nix ];

  # Clean /tmp on boot.
  boot.tmp.cleanOnBoot = true;

  # Automatically optimize the Nix store to save space
  # by hard-linking identical files together. These savings
  # add up.
  nix.settings.auto-optimise-store = true;

  # Limit the systemd journal to 100 MB of disk or the
  # last 7 days of logs, whichever happens first.
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=7day
  '';

  # system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "23.11"; # Did you read the comment?
}
