{ pkgs, ... }: {
  _class = "homeManager";
  requiredSystemModules = [ ];
  home.packages = with pkgs; [ texlive.combined.scheme-full ];
}
