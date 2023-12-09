{ pkgs, lib, config, ... }: {
  environment.systemPackages = [ pkgs.keepassxc ];
  services.gnome.gnome-keyring.enable = lib.mkForce false;
  programs.ssh.startAgent = true;
  home-manager-desktop.services.gnome-keyring.enable = false;
  home-manager-desktop.home.file."/.config/keepassxc/keepassxc.ini" = {
    onChange =
      "cp /home/$USER/.config/keepassxc/keepassxc.ini /home/$USER/repos/nixconfigs/packages/configs";
    source = ./configs/keepassxc.ini;
  };


  # security.pam.enableSSHAgentAuth
  # Enable sudo logins if the user’s SSH agent provides a key present in ~/.ssh/authorized_keys. This allows machines to exclusively use SSH keys instead of passwords.

}
