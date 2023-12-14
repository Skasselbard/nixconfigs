{ lib, config, pkgs, ... }:

with lib;
with pkgs; {
  # https://nix-community.github.io/home-manager/

  options = with types; {
    ## mkpasswd -m sha-512
    hashedUserPwd = mkOption {
      type = nullOr str;
      default = null;
    };
    sshKey = mkOption {
      type = str;
      default = "";
    };
    adminUsers = mkOption { # TODO: better var name?
      type = nullOr (listOf str);
      description = "List of users with admin priviliges";
    };
  };

  config = {
    users.mutableUsers = mkDefault false;
    users.extraUsers = listToAttrs (map (elem: {
      name = elem;
      value = {
        isNormalUser = mkForce true;
        extraGroups = [ "wheel" "docker" "libvirtd" "networkmanager" ];
        shell = mkForce nushellFull;
        hashedPassword = mkDefault config.hashedUserPwd;
        openssh.authorizedKeys.keys = mkDefault [ config.sshKey ];
      };
    }) config.adminUsers) // {
      root = {
        openssh.authorizedKeys.keys = mkDefault [ config.sshKey ];
        shell = nushellFull;
      };
    };
  };
}
