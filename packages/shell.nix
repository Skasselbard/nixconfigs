{
  # bash.enable = true;
  # nushell.enable = true;
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    # autocd = true;
    # history.expireDuplicatesFirst = true;
    # history.ignoreDups = true;
    ohMyZsh = {
      enable = true;
      theme = "agnoster";
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
