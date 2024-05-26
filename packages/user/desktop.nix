{ pkgs, config, ... }:
with builtins; {
  _class = "homeManager";
  imports = [ ./gnome.nix ];
  requiredSystemModules = [ ../system/desktop.nix ];

  home.packages = with pkgs; [
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
    # skypeforlinux
    spotify
    virt-manager
    vlc
    zotero
    # zoom-us

    # discord
    # kicad
    # okular
  ];
  programs = {
    obs-studio.enable = true;
    vscode.enable = true;
  };
  services = {
    # flameshot.enable = true;
    # keepassx.enable = true;
  };
}
