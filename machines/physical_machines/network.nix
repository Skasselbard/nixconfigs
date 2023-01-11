{ lib, config, ... }:
with lib; {
  options = with types; {
    hostname = mkOption { type = str; };
    ip = mkOption { type = str; };
    interface = mkOption { type = str; };
    gateway = mkOption { type = str; };
    bridgename = mkOption { type = str; };
    nameservers = mkOption {
      type = listOf str;
      default = [ "8.8.8.8" ];
    };
    # domain = mkOption{type=types.str;};
  };

  config = {

    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    networking = {
      hostName = config.hostname;
      # domain = config.domain;
      nameservers = config.nameservers;
      bridges = {
        "${config.bridgename}" = { interfaces = [ config.interface ]; };
      };
      interfaces.${config.bridgename} = {
        # wakeOnLan.enable = true;
        ipv4.addresses = [{
          address = config.ip;
          prefixLength = 24;
        }];
      };
      defaultGateway = {
        address = config.gateway;
        interface = config.bridgename;
      };
      # extraHosts = {
      #   "127.0.0.1" = [ "foo.bar.baz" ];
      #   "192.168.0.2" = [ "fileserver.local" "nameserver.local" ];
      # };
    };
  };
}
