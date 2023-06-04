{ pkgs, config, ... }:
let
  etcdName = "atom-etcd";
  username = "tom";
  host_interface = "eno1";
  etcdIP = "192.168.1.11";
  # etcdPkgs = (builtins.fetchGit {
  #   url = "https://github.com/NixOS/nixpkgs";
  #   ref = "refs/heads/nixos-22.11";
  # }).outPath;
in {

  # delay the etcd container until the network is set up
  # Sometimes the network service crashes. Restarting the network service in the container (from the host with nixos-container) fixes this issue
  systemd.services."container@${etcdName}" = {
    after = [ "network-setup.service" ];
  };

  # TODO: fix nix version for k3s
  containers = let
  in {
    "${etcdName}" = {
      config = { pkgs, ... }: {
        # FIXME: make ssh server conditional
        imports = [ ../containers/atom-etcd.nix ];
        config = {
          systemd.services.k3s = {
            requires = [ "network-setup.service" ];
            after = [ "network-setup.service" ];
          };
          # ports: https://docs.k3s.io/installation/requirements
          networking.firewall.allowedTCPPorts = [ 6443 2379 2380 ];
          services.k3s.enable = true;
          services.k3s.role = "server";
          services.k3s.extraFlags = "--node-ip ${etcdIP}";
          environment.etc."rancher/k3s/config.yaml" = {
            source = ../kubernetes/server-config.yaml;
          };
          environment.systemPackages = [ pkgs.k3s ];
          # TODO: logs https://docs.k3s.io/faq#where-are-the-k3s-logs
          security.sudo.extraConfig = ''
            ${username} ALL = NOPASSWD: ${pkgs.coreutils-full}/bin/cat /var/lib/rancher/k3s/server/token
            ${username} ALL = NOPASSWD: ${pkgs.k3s}/bin/k3s
          '';
        };
      };
      macvlans = [ host_interface ];
      autoStart = true;
      bindMounts = {
        "/var/lib/rancher/k3s/server/manifests/dashboard.yaml".hostPath =
          "${../../Stage_3/dashboard.yaml}";
        "/var/lib/rancher/k3s/server/manifests/argocd.yaml".hostPath =
          "${../../Stage_3/argocd.yaml}";
      };
      # nixpkgs = etcdPkgs; FIXME:
    };
  };
}
