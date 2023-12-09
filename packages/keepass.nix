{ pkgs, lib, config, ... }: {
  environment.systemPackages = [ pkgs.keepassxc ];
  services.gnome.gnome-keyring.enable = lib.mkForce false;
  home-manager-desktop.services.gnome-keyring.enable = false;
  home-manager-desktop.home.file."/.config/keepassxc/keepassxc.ini" = {
    onChange =
      "cp $HOME/.config/keepassxc/keepassxc.ini $HOME/repos/nixconfigs/packages/configs";
    source = ./configs/keepassxc.ini;
  };
}
