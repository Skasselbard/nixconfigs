# Nixos K3s Cluster

Build and deploy a NixOs k3s cluster according to a set of plans.
TODO: link NixOS and other stuff

## Setup

Checkout folder structure
```shell
curl smth smth
```

You may want to backup your plans for example in a git repo.
TODO: Link to create a repo from folder.

## Assumptions

- Access to the internet
- K3s is run in containers on one or more host machines
- The k3s server is running in a [nixos-container](https://nixos.wiki/wiki/NixOS_Containers) (because it is an easy nixos integration)
- The k3s agent runs in a podman container (because it needs to be privileged access, which I couldn't figure out for the nixos-containers)
- Every host and k3s container have a static IP address
- Each host can run at most one k3s server and agent
  - hosts can be defined without k3s containers for additional deployments
- The network is configured as macvlan
  - including the host configuration
- All machines and containers are in the same subnet with the same gateway
  - which of course should be reachable from the deploying machine
- The nix confiiguration is built on the deploying machine
- Each host has an admin user
  - The admin user on the k3s server (if it exists) has the same admin user
- hosts are accessable by ssh
  - k3s servers share the ssh keys with the host or disable ssh access
  - ssh connections prohibit passwords and root logins (only ssh keys are allowed)

## Configuration

TODO: fill in plans

## Build Boot Stick for Host

```shell
nix-shell --run "create_boot_stick hostname /dev/usb/device"
```

## Build Cluster

```shell
nix-shell --run "build"
```

Populates the templates according to the plans and runs colmena build.
Keeps the populated plans.

## Deploy Cluster

```shell
nix-shell --run "deploy"
```

Populates the templates according to the plans and runs colmena deploy.
Deletes the populated plans after completion.
