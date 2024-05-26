{ config, pkgs, lib, username, ... }:

{
  _class = "homeManager";
  options = with lib;
    with types; {
      gitUser = mkOption { type = str; };
      gitMail = mkOption { type = str; };
      requiredSystemModules = mkOption { type = listOf path; };
    };
  imports = [ ./shell ];

  config = {
    requiredSystemModules = [ ../system ];

    home = {
      # inherit username;
      stateVersion = "23.11";
    };

    programs = {
      git = {
        enable = true;
        package = pkgs.gitSVN;
        userName = config.gitUser;
        userEmail = config.gitMail;
      };
      # Let Home Manager install and manage itself.
      home-manager.enable = lib.mkDefault false; # not on nixos
    };
  };
}
