{
  services.printing.enable = true;
  networking.networkmanager.enable = true;

  desktopPackages = [
    appimage-run
    firefox
    gparted
      gnomeExtensions.dash-to-dock # gnome app menu
    inkscape
    krita
    obsidian
    libsForQt5.okular
    peek
    remmina
    signal-desktop
    skypeforlinux
    spotify
    virt-manager
    vlc
    zotero
    jabref
    zoom-us
  ];
  home-manager-services = {
    flameshot.enable = true;
    keepassx.enable = true;
  };
  home-manager-programs = {
    obs-studio.enable = true;
    vscode.enable = true;
  };
}
