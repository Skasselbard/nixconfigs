{ lib, config, ... }:
with lib;
with types; {
  options = {
    hostname = mkOption { type = str; };
    ip = mkOption { type = nullOr str; };
    interface = mkOption { type = nullOr str; };
  };

  imports = [ ../default.nix ];

  config = {
    networking = {
      hostName = config.hostname;
      interfaces = if config.ip == null && config.interface == null then {
        "${config.interface}" = {
          ipv4.addresses = [{
            address = config.ip;
            prefixLength = 24;
          }];
        };
      } else
        { };

      defaultGateway = {
        address = "192.168.1.1"; # router address
        interface = "${config.interface}"; # go to other nets through the bridge
      };
    };
  };
}
