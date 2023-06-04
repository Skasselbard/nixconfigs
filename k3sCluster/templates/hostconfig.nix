{
  # imports = [{{network.module}}];

  cluster = {
    admin = {
      name = "{{admin.name}}";
      hashedPwd = "{{admin.pwd}}";
      # mkpasswd -m sha-512
      # sshKeys = [{{admin.sshKeys}}];
    };

    k3s = {
      # TODO: if no server is configured, populate the server fields with the init server
      # server.enable = {{k3s.server.enable}};
      server.name = "{{k3s.server.name}}";
      server.ip = "{{k3s.server.ip}}";
      # server.init.enabled = {{k3s.server.init.enabled}};
      server.init.ip = "{{k3s.server.init.ip}}";
      # server.ssh.enable = {{k3s.server.ssh.enable}};
      # agent.enable = {{k3s.agent.enable}};
      agent.name = "{{k3s.agent.name}}";
      agent.ip = "{{k3s.agent.ip}}";
      tokenFilePath = "{{k3s.}}";
    };

    network = {
      host.interface = "{{network.host.interface}}";
      host.name = "{{network.host.name}}";
      host.ip = "{{network.host.ip}}";
      subnet = "{{network.subnet}}";
      gateway = "{{network.gateway}}";
    };

    version = {
      k3s = "{{version.k3s}}";
      # etcdPkgs = (builtins.fetchGit {
      #   url = "https://github.com/NixOS/nixpkgs";
      #   ref = "refs/heads/nixos-22.11";
      # }).outPath;
    };
  };
}
