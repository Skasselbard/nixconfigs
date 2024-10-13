{ pkgs, lib, config, ... }: {
  environment.systemPackages = [ pkgs.keepassxc ];
  services.gnome.gnome-keyring.enable = lib.mkForce false;
  programs.ssh.startAgent = true;
  security.pam.sshAgentAuth.enable = true;
}
