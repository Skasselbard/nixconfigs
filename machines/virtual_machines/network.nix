{ lib, config, ... }:
with lib; {
  options = with types; {
    hostname = mkOption { type = str; };
    ip = mkOption { type = str; };
    interface = mkOption { type = str; };
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
        interface = config.interface;
      };
      # extraHosts = {
      #   "127.0.0.1" = [ "foo.bar.baz" ];
      #   "192.168.0.2" = [ "fileserver.local" "nameserver.local" ];
      # };
    };
  };
}
