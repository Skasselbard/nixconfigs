{ pkgs, ... }: {
  # bash.enable = true;
  # nushell.enable = true;
  environment = {
    systemPackages = with pkgs; [ nerdfonts zsh-powerlevel10k ];
  };
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    promptInit = ''
      export POWERLEVEL9K_MODE=nerdfont-complete
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${./p10k.zsh}
      LINUX_ICON='🐧' # '☢'
      sshamnesia() {
        ssh -o 'UserKnownHostsFile=/dev/null' -o 'StrictHostKeyChecking=no' -o 'LogLevel=ERROR' $1
      }
    '';
    # autocd = true;
    # options: https://manpages.debian.org/testing/zsh-common/zshoptions.1.en.html
    setOptions = [
      "HIST_IGNORE_DUPS"
      "SHARE_HISTORY"
      "HIST_FCNTL_LOCK"
      "HIST_EXPIRE_DUPS_FIRST"
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
        "podman"
        "python"
        "rust"
        "sudo"
        "svn"
        "teraform"
        "vscode"
      ];
    };
  };
}
