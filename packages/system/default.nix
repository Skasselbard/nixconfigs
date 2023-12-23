{ lib, pkgs, config, ... }: {
  imports = [ ./shell.nix ./ssh.nix ./prometheus.nix ];

  config = with pkgs;
    with builtins; {

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
        ntfs3g # TODO: not as default?
        vim
        wget
        yq-go # YAML processor
        zsh
        zsh-git-prompt
      ];
    };
}
