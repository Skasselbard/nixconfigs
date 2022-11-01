{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  programs.dconf.enable = true;
  
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

  home-manager = {
    users.tom = { pkgs, ... }: with pkgs; {
      home.packages = with pkgs; [
        gnomeExtensions.forge # window tiling
        gnomeExtensions.vitals # coretemps etc.
        gnomeExtensions.runcat
        gnomeExtensions.kubectl-extension
      ];
      dconf.settings = { pkgs, ... }: with pkgs; {
      # gnome shell settings from https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
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
}

