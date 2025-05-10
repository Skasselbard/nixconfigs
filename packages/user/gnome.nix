{
  pkgs,
  lib,
  config,
  ...
}:
with builtins;
with lib;
let
  suspress_idle_loggoff = true;
in
{
  _class = "homeManager";
  requiredSystemModules = [ ../system/desktop.nix ];
  home.packages = with pkgs; [
    gnomeExtensions.color-picker
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
    "org/gnome/shell/keybindings" = {
      toggle-overview = [ "<Alt>F1" ];
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
    "org/gnome/Console" = {
      shell = [ "${pkgs.zsh}/bin/zsh" ];
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
    "org/gnome/mutter" = {
      edge-tiling = true;
    };
    "org/gnome/shell/extensions/tiling-assistant" = {
      enable-tiling-popup = false;
      window-gap = 0;
      single-screen-gap = 0;
      dynamic-keybinding-behavior = 2;
      active-window-hint = 1;
    };
    "org/gnome/settings-daemon/plugins/power" = mkIf suspress_idle_loggoff {
      sleep-inactive-ac-type = "suspend";
      sleep-inactive-ac-timeout = 21600; # 6h
    };
    "org/gnome/desktop/session" = mkIf suspress_idle_loggoff { idle-delay = 0; };
  }; # dconf.settings
}
