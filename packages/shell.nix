{
  home-manager-programs = {
    bash.enable = true;
    nushell.enable = true;
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      autocd = true;
      history.expireDuplicatesFirst = true;
      history.ignoreDups = true;
      oh-my-zsh = {
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
  };
}
