{
  # mount zotero with sshfs  
  system.fsPackages = [ pkgs.sshfs ];
  fileSystems."/home/tom/zotero" = {
    device = "tmeyer@honshu.informatik.uni-rostock.de:Zotero/";
    fsType = "sshfs";
    options =
      [ # Filesystem options
        "allow_other"          # for non-root access
        "_netdev"              # this is a network fs
        "x-systemd.automount"  # mount on demand

        # SSH options
        "reconnect"              # handle connection drops
        "ServerAliveInterval=15" # keep connections alive
        # make sure the id is copied correctly
        # e.g ssh-copyid -i /root/.ssh/id_rsa.pub user@remote
        # "IdentityFile=/root/.ssh/id_rsa"
        # "debug"
      ];
  };
}