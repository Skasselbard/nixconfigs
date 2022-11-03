{ pkgs, ... }: {
  imports = [ ./shell.nix ./ssh.nix ./prometheus.nix ];

  options = {
    gitUser = mkOption { type = types.str; };
    gitMail = mkOption { type = types.str; };
  };

  config = {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
    # accessible for all
    environment.systemPackages = with pkgs; [
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
    home-manager-programs = {
      git = {
        enable = true;
        package = gitSVN;
        userName = config.gitUser;
        userEmail = config.gitMail;
      };
    };
  };
}
