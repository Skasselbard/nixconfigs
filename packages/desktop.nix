{ pkgs, config, ... }:
with builtins; {
  services.printing.enable = true;
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    appimage-run
    firefox
    gparted
    gnomeExtensions.dash-to-dock # gnome app menu
    inkscape
    jabref
    krita
    obsidian
    libsForQt5.okular
    libreoffice
    peek
    remmina
    meld # diff viewer
    signal-desktop
    skypeforlinux
    spotify
    virt-manager
    vlc
    zotero
    jabref
    zoom-us

    # discord
    # kicad
    # okular
    # peek
  ];
  home-manager-desktop = {
    programs = {
      obs-studio.enable = true;
      vscode.enable = true;
    };
    services = {
      # flameshot.enable = true;
      # keepassx.enable = true;
    };
  };
}
