{
  # imports = [{{network.module}}];

  cluster = {

    init.ip = "{{k3s.server.init.ip}}";
    host = {
      name = "{{host.name}}";
      admin = {
        name = "{{host.admin.name}}";
        hashedPwd = "{{admin.pwd}}";
        # mkpasswd -m sha-512
        # sshKeys = [{{admin.sshKeys}}];
      };
      interface = "{{network.host.interface}}";
      ip = "{{network.host.ip}}";
      gateway = "{{network.gateway}}";
    };

    k3s = {
      # TODO: if no server is configured, populate the server fields with the init server
      # server.enable = {{k3s.server.enable}};
      server.name = "{{k3s.server.name}}";
      server.ip = "{{k3s.server.ip}}";
      # server.clusterInit = {{k3s.server.clusterInit}};
      # server.ssh.enable = {{k3s.server.ssh.enable}};
      # agent.enable = {{k3s.agent.enable}};
      agent.name = "{{k3s.agent.name}}";
      agent.ip = "{{k3s.agent.ip}}";
      tokenFilePath = "{{k3s.}}";
      version = {
        k3s = "{{version.k3s}}";
        # etcdPkgs = (builtins.fetchGit {
        #   url = "https://github.com/NixOS/nixpkgs";
        #   ref = "refs/heads/nixos-22.11";
        # }).outPath;
      };
    };

  };
}
