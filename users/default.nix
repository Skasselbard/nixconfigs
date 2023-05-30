{ lib, config, pkgs, ... }:

with lib;
with pkgs; {
  #TODO: use home manager?
  # https://nix-community.github.io/home-manager/

  options = with types; {
    ## mkpasswd -m sha-512
    # hashedRootPwd = mkOption{type = types.str;};
    hashedUserPwd = mkOption {
      type = nullOr str;
      default = null;
    };
    sshKey = mkOption {
      type = str;
      default = "";
    };
  };

  imports = [ ../packages/shell.nix ];

  config = {
    users.mutableUsers = false;
    users.extraUsers = {
      root.openssh.authorizedKeys.keys = [ config.sshKey ];

      tom = {
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" "libvirtd" "networkmanager" ];
        shell = zsh;
        hashedPassword = config.hashedUserPwd;
        openssh.authorizedKeys.keys = [ config.sshKey ];
      };
    };
  };
}
