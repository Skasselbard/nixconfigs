{ lib, config, ... }:
with lib;
{
  options = {
    hostname = mkOption{type = types.str;};
    ip = mkOption{type = types.str;};
    interface = mkOption{type=types.str;};
    # domain = mkOption{type=types.str;};
  };

  config = {
    networking = {
      hostName = config.hostname;
      # domain = config.domain;
      nameservers = ["8.8.8.8"];
      interfaces.${config.interface} = {
        ipv4.addresses = [ {
            address = config.ip;
            prefixLength = 24;
          } ];
      };
      defaultGateway = {
        address = "192.168.1.1";
        interface = "${config.interface}";
      };
      # extraHosts = {
      #   "127.0.0.1" = [ "foo.bar.baz" ];
      #   "192.168.0.2" = [ "fileserver.local" "nameserver.local" ];
      # };
    };
  };
}