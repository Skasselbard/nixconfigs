{ lib, config, ... }:
with lib; {
  options = {
    hostname = mkOption { type = types.str; };
    ip = mkOption { type = types.str; };
    interface = mkOption { type = types.str; };
    bridgename = mkOption { type = types.str; };
    # domain = mkOption{type=types.str;};
  };

  config = {

    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    networking = {
      hostName = config.hostname;
      # domain = config.domain;
      nameservers = [ "8.8.8.8" ];
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
        address = "192.168.1.1";
        interface = "${config.bridgename}";
      };
      # extraHosts = {
      #   "127.0.0.1" = [ "foo.bar.baz" ];
      #   "192.168.0.2" = [ "fileserver.local" "nameserver.local" ];
      # };
    };
  };
}
