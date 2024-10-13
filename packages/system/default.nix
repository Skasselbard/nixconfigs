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
        mdadm
        nixos-generators
        nixfmt-rfc-style
        # nix-inspect // TODO. include when available
        ntfs3g # TODO: not as default?
        vim
        wget
        yq-go # YAML processor
        zsh
        zsh-git-prompt
      ];
    };
}
