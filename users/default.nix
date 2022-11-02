{ lib, config, pkgs, ... }:

with lib;
with pkgs;
{
  #TODO: use home manager?
  # https://nix-community.github.io/home-manager/

  options = {
    ## mkpasswd -m sha-512
    # hashedRootPwd = mkOption{type = types.str;};
    # hashedUserPwd = mkOption{type = types.str;};
    sshKey = mkOption{
      type = types.str;
      default = "";
    };
  };

  config = {
    users.mutableUsers = false;
    users.extraUsers = {
      root.openssh.authorizedKeys.keys = [ config.sshKey ];
       
      tom = {
        isNormalUser = true;
        extraGroups = ["wheel" "docker" "libvirtd" "networkmanager"];
        shell = zsh;
        # hashedPassword = config.hashedUserPwd;
        openssh.authorizedKeys.keys = [ config.sshKey ];
      };
    };
  };
}