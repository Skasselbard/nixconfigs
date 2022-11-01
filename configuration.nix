{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  networking.hostName = "leo"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "nodeadkeys";
  };

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # mount zotero with sshfs  
  system.fsPackages = [ pkgs.sshfs ];
  fileSystems."/home/tom/zotero" = {
    device = "tmeyer@honshu.informatik.uni-rostock.de:Zotero/";
    fsType = "sshfs";
    options =
      [ # Filesystem options
        "allow_other"          # for non-root access
        "_netdev"              # this is a network fs
        "x-systemd.automount"  # mount on demand

        # SSH options
        "reconnect"              # handle connection drops
        "ServerAliveInterval=15" # keep connections alive
        # make sure the id is copied correctly
        # e.g ssh-copyid -i /root/.ssh/id_rsa.pub user@remote
        # "IdentityFile=/root/.ssh/id_rsa"
        # "debug"
      ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tom = {
    isNormalUser = true;
    description = "Tom";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
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
  };
  home-manager = {
    useGlobalPkgs = true;
    users.tom = { pkgs, ... }: with pkgs; {
      home.packages = with pkgs; [
        gnomeExtensions.forge # window tiling
        gnomeExtensions.vitals # coretemps etc.
        gnomeExtensions.runcat
        gnomeExtensions.kubectl-extension
      ];
      services = {
        flameshot.enable = true;
        keepassx.enable = true;
      };
      programs = {
        bash.enable = true;
        # dconf.enable = true;
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
      # gnome shell settings from https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions =[
            "places-menu@gnome-shell-extensions.gcampax.github.com"
            "dash-to-dock@micxgx.gmail.com"
            "kubectl@infinicode.de"
            "runcat@kolesnikov.se"
            "Vitals@CoreCoding.com"
            "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
            ];
        };
        "org/gnome/shell/extensions/dash-to-dock" = {
          show-trash = false;
          show-show-apps-button = true;
          scroll-action = "switch-workspace";
          dock-position = "BOTTOM";
          intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
          show-apps-at-top = false;
        };
        "org/gnome/shell/keybindings" = {
          toggle-overview = ["<Alt>F1"];
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          enable-hot-corners = false;
          show-battery-percentage = true;
        };
        "org/gnome/desktop/peripherals/keyboard" = {
          numlock-state = true;
        };
        "system/locale" = {
          region = "de_DE.UTF-8";
        };
        "org/gnome/shell/extensions/kubectl" = {
          position-in-panel = "right";
        };
        "org/gnome/shell/extensions/runcat" = {
          hide-runner = false;
          hide-percentage = true;
        };
        "org/gnome/shell/extensions/auto-move-windows" = {
          application-list = [
            "signal-desktop.desktop:2"
            "spotify.desktop:2"
            ];
        };
      }; # dconf.settings

    };
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # }; 

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
