{ pkgs, ... }: {
  requiredSystemModules = [ ];
  home.packages = with pkgs; [ texlive.combined.scheme-full ];
}
