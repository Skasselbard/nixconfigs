{ pkgs, ... }: {
  # bash.enable = true;
  # nushell.enable = true;
  environment = {
    systemPackages = with pkgs; [ nerdfonts zsh-powerlevel10k ]; # FIXME: fonts
  };
  fonts.packages = with pkgs; [ nerdfonts ];
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    syntaxHighlighting.enable = true;
    promptInit = ''
      export POWERLEVEL9K_MODE=nerdfont-complete
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${./p10k.zsh}
      sshamnesia() {
        ssh -o 'UserKnownHostsFile=/dev/null' -o 'StrictHostKeyChecking=no' -o 'LogLevel=ERROR' $1
      }
    '';
    # autocd = true;
    # options: https://manpages.debian.org/testing/zsh-common/zshoptions.1.en.html
    setOptions = [
      "AUTO_CD"
      "HIST_IGNORE_DUPS"
      "HIST_FCNTL_LOCK"
      "HIST_EXPIRE_DUPS_FIRST"
      "SHARE_HISTORY"
    ];
    ohMyZsh = {
      enable = true;
      theme = "";
      plugins = [
        "adb"
        "ansible"
        "argocd"
        "aws"
        "azure"
        "command-not-found"
        "colored-man-pages"
        "dirhistory"
        "docker"
        "docker-compose"
        "dotnet"
        "extract"
        "git"
        "github"
        "gradle"
        "helm"
        "kubectl"
        "mvn"
        "node"
        "npm"
        "per-directory-history"
        "pip"
        # "podman"
        "python"
        "rust"
        "sudo"
        "svn"
        "terraform"
        "vscode"
      ];
    };
  };
}
