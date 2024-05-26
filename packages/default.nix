{ lib, pkgs, config, ... }: {

  imports = [ ./system ];

  config = {
    home-manager = { useGlobalPkgs = true; };
    # Allow unfree packages
    nixpkgs.config.allowUnfree = lib.mkDefault true;

  };
}
