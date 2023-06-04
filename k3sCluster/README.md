# Nixos K3s Cluster

Build and deploy a NixOs k3s cluster according to a set of plans.
TODO: link NixOS and other stuff

This project builds and deploys a set of NixOS hosts and runs a Kubernetes cluster in containers.
Its goal is to set up the hardware for a bare metal home cloud with a maximal level of automation.
The configuration is a set of csv tables which also document your deployments.

## Goals

1. Provide a minimal configuration for a K3s Cluster on NixOS
2. Configure a local static network and ssh access (with ssh keys)
3. Leave room for additional NixOS host configuration including non K3s nodes
4. Create installation media for an initial machine setup
5. Deploy updates and change configuration remotely once the machines are initialized
6. Keep the human interaction minimal in the process

## Non Goals

- Configure Kubernetes and Container Apps
- Cluster Access from the internet
  - you should be able to extend the NixOS config for that purpose though
- Automatic updates
  - you decide when the cluster is ready for an update

## Assumptions

To keep the configuration minimal the following assumptions were made:

- K3s runs in containers on one or more host machines
- The k3s server is running in a [nixos-container](https://nixos.wiki/wiki/NixOS_Containers) (because it is an easy NixOS integration)
- The k3s agent runs in a podman container (because it needs to be privileged access, which I couldn't figure out for the nixos-containers)
- Every host and k3s container have a static IP address
- Each host can run at most one k3s server and/or agent
  - hosts can be defined without k3s containers for additional deployments
- The network is configured as macvlan
  - including the host configuration
  - the host and the k3s containers share the same interface
- All machines and containers are in the same subnet with the same gateway
  - which of course should be reachable from the deploying machine
- The nix configuration is built on the deploying machine
- Each host has an admin user
  - The NixOS on the associated container for the k3s server (if it exists) has the same admin user
- hosts are accessible by ssh
  - k3s servers share the ssh keys with the host or disable ssh access
  - ssh connections prohibit passwords and root logins (only ssh keys are allowed)
  - the admin user has a password for sudo once an ssh connection is established

## Requirements

- Internet access
- Physical access to the NixOS hosts
  - or a ready to use NixOS on the host to deploy to

## Setup

Checkout folder structure
```shell
curl smth smth
```

You may want to backup your plans for example in a git repo.
TODO: Link to create a repo from folder.


## Configuration

TODO: fill in plans

### Example
Check the [examples](/exampls/plans) folder.

#### Hosts.csv Physical hosts
name| interface| ip| admin
|-|-|-|-|
olaf| enp0s20f0| 10.0.100.2| manfred
ulf| enp1s0| 10.0.100.3| manfred
rolf| eno2| 10.0.100.4| manfred
karl| eni1| 10.0.100.5| manfred
ulrich| eno1| 10.0.100.6| manfred

#### k3s.csv K3s Containers
host| name| type| ip| ssh-access
|-|-|-|-|-|
olaf| olaf-k3s-server| init-server| 10.0.100.10| true
olaf| olaf-k3s-agent| agent| 10.0.100.11| ignored
ulf| ulf-k3s-server| server| 10.0.100.12| false
ulf| ulf-k3s-agent| agent| 10.0.100.13| ignored
rolf| rolf-k3s-server| server| 10.0.100.14| true
karl| karl-k3s-agent| agent| 10.0.100.15| ignored

| :bulb: INFO   
|:------------------------|
| k3s Agents cannot be accessed via ssh so their ssh-access field is ignored|
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
