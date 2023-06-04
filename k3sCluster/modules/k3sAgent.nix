{ pkgs, config, ... }:
with config.cluster;
let
  etcdName = k3s.server.name;
  workerName = k3s.agent.name;
  host_interface = network.host.interface;
  etcdIP = k3s.server.ip;
  workerIP = k3s.agent.ip;
  subnet = network.subnet;
  k3sVersionTag = config.version.k3s;
  tokenFilePath = "/var/lib/nixos-containers/${etcdName}/var/lib/rancher/k3s/server/token";
in {
  # delay worker service until k3s token is initialized
  systemd.services."podman-${workerName}" = {
    # create macvlan for worker node if absent
    preStart =
      "${pkgs.podman}/bin/podman network exists ${workerName}-macvlan ||  ${pkgs.podman}/bin/podman network create --driver=macvlan --gateway=${config.gateway} --subnet=${subnet} -o parent=${host_interface} ${workerName}-macvlan";
      TODO: querry the init server host! for the token file
    unitConfig = {
      ConditionPathExists = tokenFilePath;
    };
  };

  # start the k3s agent in a privileged podman container
  # https://fictionbecomesfact.com/nixos-configuration
  virtualisation.oci-containers = {
    backend = "podman";
    containers."${workerName}" = {
      image = "rancher/k3s:${k3sVersionTag}";
      cmd = [
        "agent"
        "--token-file=/var/lib/rancher/k3s/server/token"
        "--server=https://${etcdIP}:6443"
        "--node-external-ip=${workerIP}"
      ];
      extraOptions = [
        "--privileged"
        "--hostname=${workerName}"
        "--network=${workerName}-macvlan"
        "--ip=${workerIP}"
        # "--mac-address=MAC"
      ];
      volumes = [
        "${tokenFilePath}:/var/lib/rancher/k3s/server/token"
      ];
    };
  };
}
