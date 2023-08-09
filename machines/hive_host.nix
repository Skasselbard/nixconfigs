{ lib, config, pkgs, ... }:

with builtins;
with lib;
with pkgs; {
  imports = [ ./physical_machines ../. ];
  users.extraUsers = {
    root.shell = zsh;
  } // listToAttrs (map (elem: {
    name = elem;
    value = { shell = zsh; };
  }) config.osUsers);
}
