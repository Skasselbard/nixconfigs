{ lib, config, pkgs, ... }:

with lib;
with pkgs;
{
  options = {
    password = mkOption{
      type = types.str;
    };
  };
  config ={
    users.mutableUsers = false;
    users.extraUsers.root.password = config.password;
  };
}