{ lib, config, ... }:
with lib; {
  options = {
    hostname = mkOption { type = types.str; };
    ip = mkOption { type = types.str; };
    interface = mkOption { type = types.str; };
    gateway = mkOption { type = str; };
    nameservers = mkOption { type = listOf str; };
    # domain = mkOption{type=types.str;};
  };

  config = {
    networking = {
      hostName = config.hostname;
      # domain = config.domain;
      nameservers = config.nameservers;
      interfaces.${config.interface} = {
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
