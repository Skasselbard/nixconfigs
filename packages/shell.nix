{ pkgs, ... }: {
  # bash.enable = true;
  # nushell.enable = true;
  environment.systemPackages = with pkgs; [ nerdfonts zsh-powerlevel10k ];
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    promptInit = ''
      export POWERLEVEL9K_MODE=nerdfont-complete
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${./p10k.zsh}
      LINUX_ICON='☢'
    '';
    # autocd = true;
    # options: https://manpages.debian.org/testing/zsh-common/zshoptions.1.en.html
    shellAliases = {
      sshamnesia = ''
        ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -o " LogLevel=ERROR"
      '';
    };
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
        "aws"
        "extract"
        "npm"
        "pip"
        "python"
        "git"
        "catimg"
        "command-not-found"
        "dirhistory"
        "docker"
        "adb"
        "gradle"
        "mvn"
        "rust"
        "per-directory-history"
        "sudo"
        "svn"
      ];
    };
  };
}
