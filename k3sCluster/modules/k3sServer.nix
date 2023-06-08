{ pkgs, config, lib, ... }:
with config.cluster;
with lib; {
  # delay the etcd container until the network is set up
  # Sometimes the network service crashes. Restarting the network service in the container (from the host with nixos-container) fixes this issue
  systemd.services = {
    "container@${k3s.server.name}" = { after = [ "network-setup.service" ]; };
  };

  # TODO: fix nix version for k3s
  containers = {
    "${k3s.server.name}" = let
      pkgs = import (builtins.fetchGit {
        url = "https://github.com/NixOS/nixpkgs";
        ref = "refs/heads/nixos-23.05";
      }) { };
    in {
      config = { pkgs, ... }: {
        imports = [ ]
          ++ optional (k3s.server.extraConfig != null) k3s.server.extraConfig;
        config = {
          # nixpkgs.pkgs = (import (builtins.fetchGit {
          # url = "https://github.com/NixOS/nixpkgs";
          # ref = "refs/heads/nixos-23.05";
          # }) { }).pkgs;
          systemd.services.k3s = {
            requires = [ "network-setup.service" ];
            after = [ "network-setup.service" ];
          };
          # ports: https://docs.k3s.io/installation/requirements
          networking.firewall.allowedTCPPorts = [ 6443 2379 2380 ];
          services.k3s = {
            enable = true;
            role = "server";
            disableAgent = true;
            extraFlags = concatStringsSep " \\\n "
              ([ "--node-ip ${k3s.server.ip}" ]
                ++ (optional (k3s.init.ip == k3s.server.ip) " --cluster-init")
                # TODO:
                #  ++ [ cfg.extraFlags ]
              );
            # clusterInit = mkIf (k3s.init.ip == k3s.server.ip) true;
            serverAddr = mkIf (k3s.init.ip != k3s.server.ip) k3s.init.ip;
          };
          # environment.etc."rancher/k3s/config.yaml" = {
          #   source = ../kubernetes/server-config.yaml;
          # };
          environment.systemPackages = [ pkgs.k3s ];
          security.sudo.extraConfig = ''
            ${config.cluster.admin.name} ALL = NOPASSWD: ${pkgs.coreutils-full}/bin/cat /var/lib/rancher/k3s/server/token
            ${config.cluster.admin.name} ALL = NOPASSWD: ${pkgs.k3s}/bin/k3s
          '';
        };
      };
      macvlans = [ interface ];
      autoStart = true;
      # TODO: logs https://docs.k3s.io/faq#where-are-the-k3s-logs
      # bindMounts = {
      #   "/var/lib/rancher/k3s/server/manifests/dashboard.yaml".hostPath =
      #     "${../../Stage_3/dashboard.yaml}";
      #   "/var/lib/rancher/k3s/server/manifests/argocd.yaml".hostPath =
      #     "${../../Stage_3/argocd.yaml}";
      # };
    };
  };
}
