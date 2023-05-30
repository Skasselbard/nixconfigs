{ lib, pkgs, config, ... }:
let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in {
  imports =
    [ ./ssh.nix ./prometheus.nix (import "${home-manager}/nixos") ];

  options = with lib;
    with types; {
      # TODO: git cannot be in default file if it requires options
      # gitUser = mkOption { type = str; };
      # gitMail = mkOption { type = str; };
      osUsers = mkOption { # TODO: better var name?
        type = listOf str;
        description = "List of users the packages are applyied to";
        default = [ "root" ];
      };
    };

  config = with pkgs;
    with builtins; {
      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;
      # accessible for all
      environment.systemPackages = [
        dmidecode # get bios info e.g. version: dmidecode -t bios
        exfatprogs
        git
        htop
        nixos-generators
        vim
        wget
        zsh
        zsh-git-prompt
      ];
      home-manager = {
        useGlobalPkgs = true;
        users = listToAttrs (map (elem: {
          name = elem;
          value = {
            programs = {
              git = {
                enable = true;
                package = gitSVN;
                # userName = config.gitUser;
                # userEmail = config.gitMail;
              };
            };
          };
        }) config.osUsers);
      };
    };
}
