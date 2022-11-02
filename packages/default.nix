{ pkgs, ... }: {
  imports = [ ./shell.nix ./ssh.nix ./prometheus.nix ];
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
      userName = "tom";
      userEmail = "tom.meyer89@gmail.com";
    };
  };
}
