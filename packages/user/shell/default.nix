{ ... }: {
  #TODO: custom terminal emulator? https://github.com/alacritty/alacritty
  imports = [ ./nu.nix ./starship.nix ];
  requiredSystemModules = [ ../../system/shell.nix ];
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
    };
    zsh = {
      enable = true;
      # initExtraFirst = "source $ZSH/oh-my-zsh.sh";
    };
    carapace.enable = true; # shell completions
    atuin = { # shell history
      enable = true;
      flags = [ ]; # "--disable-up-arrow" ];
      settings = {
        filter_mode_shell_up_key_binding = "directory";
        filter_mode = "directory";
        update_check = false;
        search_mode = "fuzzy";
        style = "compact";
        inline_height = 15;
        history_filter = [ "^mkpasswd" ];
      };
    };
  };
}
