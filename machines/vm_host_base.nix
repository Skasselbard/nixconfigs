{ pkgs, ... }: {
  imports = [
    ./virtual_machines/partitioning.nix
    ./virtual_machines/boot.nix
    ../locale.nix
    ../users/no_users.nix
  ];

  password = "vm";
  services.openssh.enable = true;
  # boot.postBootCommands = ''
  #     export NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos
  #     nixos-rebuild switch -I nixos-config=/etc/nixos/hosts/self/configuration.nix
  # '';
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
      nixos-rebuild boot -I nixos-config=/etc/nixos/hosts/self/configuration.nix
      reboot
    '';
  };
}
