{ pkgs, lib, config, ... }: {
  environment.systemPackages = [ pkgs.keepassxc ];
  services.gnome.gnome-keyring.enable = lib.mkForce false;
  programs.ssh.startAgent = true;
  security.pam.enableSSHAgentAuth = true;
  home-manager-desktop.services.gnome-keyring.enable = false;
  home-manager-desktop.home.file."/.config/keepassxc/keepassxc.ini" = {
    onChange =
      "cp /home/$USER/.config/keepassxc/keepassxc.ini /home/$USER/repos/nixconfigs/packages/configs";
    source = ./configs/keepassxc.ini;
  };
}
