{ lib, config, ... }:
with lib; {
  options = with types; {
    cluster = {
      hostname = mkOption { type = str; };
      ip = mkOption { type = str; };
      interface = mkOption { type = str; };
      gateway = mkOption { type = str; };
      # nameservers = mkOption {
      #   type = listOf str;
      #   default = [ "8.8.8.8" ];
      # };
      # domain = mkOption{type=types.str;};
    };
  };
  config = with config.cluster; {
    networking = {
      hostName = hostname;
      # domain = config.domain;
      # nameservers = config.nameservers;
      macvlans.vlan1 = {
        # wakeOnLan.enable = true;
        interface = interface;
        mode = "bridge";
      };
      interfaces.vlan1 = {
        ipv4.addresses = [{
          address = ip;
          prefixLength = 24; # TODO: make configurable
        }];
      };
      defaultGateway = {
        address = gateway;
        interface = "vlan1";
      };
      # TODO: add cluster nodes in /etc/hosts
      # extraHosts = {
      #   "127.0.0.1" = [ "foo.bar.baz" ];
      #   "192.168.0.2" = [ "fileserver.local" "nameserver.local" ];
      # };
    };
  };
}
