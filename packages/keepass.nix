{
  environment.systemPackages = [ pkgs.keepassxc ];
  home-manager-desktop.services.gnome-keyring.enable = false;
  home.file."/config/keepassxc.ini" = {
    # onChange = "";
    source = ./configs/keepassxc.ini;
  };
}
