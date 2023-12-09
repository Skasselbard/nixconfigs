{ pkgs, lib, config, ... }:
with builtins;
with lib;
let suspress_idle_loggoff = true;
in {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  programs.dconf.enable = true;

  # workaround for cairo-xlib error: https://github.com/NixOS/nixpkgs/issues/102137
  environment.noXlibs = lib.mkForce false;

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "nodeadkeys";
  };

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
    useGlobalPkgs = true;
    users = listToAttrs (map (elem: {
      name = elem;
      value = {
        home.packages = with pkgs; [
          gnomeExtensions.color-picker
          gnomeExtensions.kubectl-extension
          gnomeExtensions.runcat
          gnomeExtensions.tiling-assistant
          gnomeExtensions.vitals # coretemps etc.
          gnomeExtensions.window-state-manager
        ];
        dconf.settings = with pkgs; {
          # gnome shell settings from https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
          "org/gnome/shell" = {
            enabled-extensions = [
              "tiling-assistant@leleat-on-github"
              "places-menu@gnome-shell-extensions.gcampax.github.com"
              "dash-to-dock@micxgx.gmail.com"
              "kubectl@infinicode.de"
              "runcat@kolesnikov.se"
              "Vitals@CoreCoding.com"
              "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
              "window-state-manager@kishorv06.github.io"
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
          "org/gnome/shell/keybindings" = { toggle-overview = [ "<Alt>F1" ]; };
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            enable-hot-corners = false;
            show-battery-percentage = true;
          };
          "org/gnome/desktop/peripherals/keyboard" = { numlock-state = true; };
          "system/locale" = { region = "de_DE.UTF-8"; };
          "org/gnome/shell/extensions/kubectl" = {
            position-in-panel = "right";
          };
          "org/gnome/shell/extensions/runcat" = {
            hide-runner = false;
            hide-percentage = true;
          };
          "org/gnome/shell/extensions/auto-move-windows" = {
            application-list =
              [ "signal-desktop.desktop:2" "spotify.desktop:2" ];
          };
          "org/gnome/shell" = {
            favorite-apps = [
              "org.gnome.Nautilus.desktop"
              "org.gnome.Console.desktop"
              "firefox.desktop"
              "signal-desktop.desktop"
              "code.desktop"
              "obsidian.desktop"
              "org.remmina.Remmina.desktop"
              "virt-manager.desktop"
              "org.inkscape.Inkscape.desktop"
              "org.kde.krita.desktop"
              "com.uploadedlobster.peek.desktop"
              "spotify.desktop"
            ];
          };
          "org/gnome/mutter" = { edge-tiling = true; };
          "org/gnome/shell/extensions/tiling-assistant" = {
            enable-tiling-popup = false;
            window-gap = 0;
            single-screen-gap = 0;
            dynamic-keybinding-behavior = 2;
            active-window-hint = 1;
          };
          "org/gnome/settings-daemon/plugins/power" =
            mkIf suspress_idle_loggoff {
              sleep-inactive-ac-type = "suspend";
              sleep-inactive-ac-timeout = 21600; # 6h
            };
          "org/gnome/desktop/session" = mkIf suspress_idle_loggoff {
            idle-delay = 0;
          };
        }; # dconf.settings
      };
    }) config.adminUsers);
  };
}

