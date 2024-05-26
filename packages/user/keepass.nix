{ pkgs, lib, config, ... }: {

  _class = "homeManager";
  requiredSystemModules = [ ../system/keepass.nix ];
  services.gnome-keyring.enable = false;
  home.file."/.config/keepassxc/keepassxc.ini" = {
    onChange =
      "cp /home/$USER/.config/keepassxc/keepassxc.ini /home/$USER/repos/nixconfigs/packages/configs";
    source = ../configs/keepassxc.ini;
  };
  # TODO:
  # - rclone sync from server https://github.com/nix-community/home-manager/issues/2703 
  # - synchronize secrets folder with nas https://rclone.org/docs/#configuration-encryption
}
