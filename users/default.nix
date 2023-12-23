{ lib, config, pkgs, ... }:

with lib;
with pkgs;
with builtins; {
  # https://nix-community.github.io/home-manager/

  options = with types; {
    ## mkpasswd -m sha-512
    userConfigs = mkOption {
      type = listOf attrs;
      description = ''
        A list of home configurations created with user level package templates.
        Used to detremine the required system packages.
      '';
      default = [ ];
      example = [
        (import ./defaultAdmin {
          pswdHash = "$6$lskjdfhalsjhdaslj";
          sshKeys = [ "olijdsfjklhsdfgvkjlhdfvsgkjhlsdfvgjkhl" ];
          homeModules = [ ../packages/user/desktop.nix ];
        })
      ];
    };
  };

  config = {
    users.mutableUsers = mkDefault false;

    home-manager.users = listToAttrs (map (config: {
      name = config.name;
      value = import ../packages/user {
        inherit pkgs lib;
        userConfig = config.userConfig;
        username = config.name;
        modules = config.homeModules;
      };
    }) config.userConfigs);
    users.users = listToAttrs (map (config: {
      name = config.name;
      value = config.systemConfig;
    }) config.userConfigs);
  };
}
