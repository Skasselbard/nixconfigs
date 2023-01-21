{ pkgs, ... }: {
  imports = [
    # includes can not contain device specific options
    ./virtual_machines/partitioning.nix
    ./virtual_machines/boot.nix
    ../default.nix
  ];

  systemd.services.nixos_configure = {
    path = with pkgs; [ nixos-rebuild ];
    environment = {
      NIX_PATH = "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos";
    };
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    script = ''
      nixos-rebuild boot -I nixos-config=/etc/nixos/configuration.nix
      reboot
    '';
  };
}
