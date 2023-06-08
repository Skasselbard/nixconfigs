{ config, lib, ... }: {
  options = with lib;
    with types; {
      cluster.k3s = {
        init = {
          ip = mkOption {
            type = nullOr str;
            default = null;
          };
        };
        server = {
          name = mkOption {
            type = nullOr str;
            default = null;
          };
          ip = mkOption {
            type = nullOr str;
            default = null;
          };
          extraConfig = mkOption {
            type = nullOr path;
            default = null;
          };
        };
        agent = {
          name = mkOption {
            type = nullOr str;
            default = null;
          };
          ip = mkOption {
            type = nullOr str;
            default = null;
          };
        };
      };
    };
}
