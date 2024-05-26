{ lib, config, pkgs, ... }:

with lib;
with pkgs;
with builtins; {

  config = { users.mutableUsers = mkDefault false; };
}
