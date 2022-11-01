{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in
{
  systemPackages = with pkgs; [
    docker
    exfatprogs
    git
    htop
    jdk17
    kubectl
    llvm
    python3Full
    texlive.combined.scheme-full    
    vim
    wget
    zsh
    zsh-git-prompt
  ];
  
  usersPackages = [
    appimage-run 
    clang
    gnomeExtensions.dash-to-dock # gnome app menu
    dmidecode # get bios info e.g. version: dmidecode -t bios
    firefox
    gparted
    gradle
    inkscape
    jabref
    krita
    obsidian
    libsForQt5.okular     
    maven
    peek
    remmina
    rustup
    signal-desktop
    skypeforlinux
    spotify
    virt-manager
    vlc
    zoom-us
    zotero
    guake

    # keepass2
    # steam

    # buildutils
    # dot
    # rust
  ];


  home-managerServices = {
        flameshot.enable = true;
        keepassx.enable = true;
      };
  home-manager.Programs = {
    bash.enable = true;
    nushell.enable = true;
    obs-studio.enable = true;
    vscode.enable = true; 
    zsh = {
     enable = true;
     enableAutosuggestions = true;
     enableCompletion = true;
     enableSyntaxHighlighting = true;
     autocd = true;
     history.expireDuplicatesFirst = true;
     history.ignoreDups = true;
     oh-my-zsh = {
       enable = true;
       theme = "agnoster";
       plugins = ["aws" "extract" "npm" "pip" "python" "git" "catimg" "command-not-found" "dirhistory" "docker" "adb" "gradle" "mvn" "rust" "per-directory-history" "sudo" "svn"];
     };
    };
    git = {
      enable = true;
      package = gitSVN;
      userName = "tom";
      userEmail = "tom.meyer89@gmail.com";
    };
  };

}
