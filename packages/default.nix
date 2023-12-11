{ lib, pkgs, config, ... }:
let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in {
  imports = [
    ./shell.nix
    # ./ssh.nix 
    ./prometheus.nix
    (import "${home-manager}/nixos")
  ];

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
      home-manager-desktop = mkOption {
        type = attrs;
        default = {
          home = { };
          programs = { };
          services = { };
          systemd = { };
        };
      };
    };

  config = with pkgs;
    with builtins; {
      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;
      # accessible for all
      environment.systemPackages = [
        dmidecode # get bios info e.g. version: dmidecode -t bios
        docker
        exfatprogs
        git
        htop
        kubectl
        nixos-generators
        nixfmt
        vim
        wget
        yq-go # YAML processor
        zsh
        zsh-git-prompt
      ];
      home-manager = {
        useGlobalPkgs = true;
        users = listToAttrs (map (elem: {
          name = elem;
          value = {
            home = {
              stateVersion = "23.11";
            } // config.home-manager-desktop.home;
            systemd = config.home-manager-desktop.systemd;
            services = config.home-manager-desktop.services;
            programs = config.home-manager-desktop.programs // {
              bash.enable = true;
              nushell = { enable = true; };
              zsh = {
                enable = true;
                initExtraFirst = "source $ZSH/oh-my-zsh.sh";
              };
              git = {
                enable = true;
                package = gitSVN;
                userName = elem;
                # userEmail = config.gitMail;
              };
            };
          };
        }) (config.adminUsers ++ config.osUsers));
      };
    };
}
