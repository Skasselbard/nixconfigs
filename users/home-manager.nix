{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in {
  imports = [ (import "${home-manager}/nixos") ];
  home-manager = {
    useGlobalPkgs = true;
    users.tom = { pkgs, ... }:
      with pkgs; {
        services = home-manager-services;
        programs = home-manager-programs;
      };
  };
}
