{ pkgs, config, ... }:
with builtins;
{
  _class = "homeManager";
  imports = [ ./gnome.nix ];
  requiredSystemModules = [ ../system/desktop.nix ];

  home.packages = with pkgs; [
    appimage-run
    firefox
    peek
  ];
}
