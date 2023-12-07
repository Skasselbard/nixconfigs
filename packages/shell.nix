{ pkgs, ... }: {
  # bash.enable = true;
  # nushell.enable = true;
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    # autocd = true;
    # options: https://manpages.debian.org/testing/zsh-common/zshoptions.1.en.html
    shellAliases = {
      sshamnesia = ''
        ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -o " LogLevel=ERROR" 192.168.1.2'';
    };
    setOptions = [
      "HIST_IGNORE_DUPS"
      "SHARE_HISTORY"
      "HIST_FCNTL_LOCK"
      "HIST_EXPIRE_DUPS_FIRST"
    ];
    ohMyZsh = {
      enable = true;
      theme =
        "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.theme";
      customPkgs = [ pkgs.zsh-powerlevel10k ];
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
