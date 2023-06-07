# This is an auto generated file.
{
  karl = {
    imports = [
      ./modules/admin.nix
      ./modules/network.nix
      ./modules/ssh.nix
      ./modules/k3sAgent.nix
      ];
    deployment.targetHost = "10.0.100.5";
    cluster = {hostname = "karl";}//
        builtins.fromJSON(''
      {
        "admin": {
          "hashedPwd": "NOT IMPLEMENTED",
          "name": "manfred"
        },
        "interface": "eni1",
        "ip": "10.0.100.5",
        "k3s": {
          "agent": {
            "ip": "10.0.100.15",
            "name": "karl-k3s-agent",
            "ssh-access": "true"
          }
        }
      }
    '');
  };
  olaf = {
    imports = [
      ./modules/admin.nix
      ./modules/network.nix
      ./modules/ssh.nix
      ./modules/k3sServer.nix
      ./modules/k3sAgent.nix
      ];
    deployment.targetHost = "10.0.100.2";
    cluster = {hostname = "olaf";}//
        builtins.fromJSON(''
      {
        "admin": {
          "hashedPwd": "NOT IMPLEMENTED",
          "name": "manfred"
        },
        "interface": "enp0s20f0",
        "ip": "10.0.100.2",
        "k3s": {
          "agent": {
            "ip": "10.0.100.11",
            "name": "olaf-k3s-agent",
            "ssh-access": "true"
          },
          "server": {
            "ip": "10.0.100.10",
            "name": "olaf-k3s-server",
            "ssh-access": "true"
          }
        }
      }
    '');
  };
  rolf = {
    imports = [
      ./modules/admin.nix
      ./modules/network.nix
      ./modules/ssh.nix
      ./modules/k3sServer.nix
      ];
    deployment.targetHost = "10.0.100.4";
    cluster = {hostname = "rolf";}//
        builtins.fromJSON(''
      {
        "admin": {
          "hashedPwd": "NOT IMPLEMENTED",
          "name": "manfred"
        },
        "interface": "eno2",
        "ip": "10.0.100.4",
        "k3s": {
          "server": {
            "ip": "10.0.100.14",
            "name": "rolf-k3s-server",
            "ssh-access": "true"
          }
        }
      }
    '');
  };
  ulf = {
    imports = [
      ./modules/admin.nix
      ./modules/network.nix
      ./modules/ssh.nix
      ./modules/k3sServer.nix
      ./modules/k3sAgent.nix
      ];
    deployment.targetHost = "10.0.100.3";
    cluster = {hostname = "ulf";}//
        builtins.fromJSON(''
      {
        "admin": {
          "hashedPwd": "NOT IMPLEMENTED",
          "name": "manfred"
        },
        "interface": "enp1s0",
        "ip": "10.0.100.3",
        "k3s": {
          "agent": {
            "ip": "10.0.100.13",
            "name": "ulf-k3s-agent",
            "ssh-access": "true"
          },
          "server": {
            "ip": "10.0.100.12",
            "name": "ulf-k3s-server",
            "ssh-access": "true"
          }
        }
      }
    '');
  };
  ulrich = {
    imports = [
      ./modules/admin.nix
      ./modules/network.nix
      ./modules/ssh.nix
      ];
    deployment.targetHost = "10.0.100.6";
    cluster = {hostname = "ulrich";}//
        builtins.fromJSON(''
      {
        "admin": {
          "hashedPwd": "NOT IMPLEMENTED",
          "name": "manfred"
        },
        "interface": "eno1",
        "ip": "10.0.100.6",
        "k3s": {}
      }
    '');
  };
}
