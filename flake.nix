{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    crane.url = "github:ipetkov/crane/v0.15.1";
  };

  outputs = { self, nixpkgs, home-manager, crane, ... }: {
    nixosModules = with import nixpkgs { system = "x86_64-linux"; };
      with pkgs.lib; {
        default = { config, ... }: {
          imports = [
            "${nixpkgs}/nixos/modules/profiles/minimal.nix"
            "${self}/default.nix"
          ];
        };
        users = { config, ... }: {
          imports = [ "${self}/usesrs/default.nix" ];
        };
        resolveRequirements = { userConfigs, pkgs }:
          (concatMap (module:
            # IMPORTANT: This import requires that every user module is a function that can be called
            # AND that a (possibly empty) list named 'requiredSystemModules' exists.
            (import module {
              inherit pkgs;
              config = { };
              lib = pkgs.lib;
            }).requiredSystemModules)
            (concatMap (userConfig: userConfig.homeModules) userConfigs));
        userConfig = import "${self}/users/userConfig.nix";
        defaultAdmin = import "${self}/users/defaultAdmin.nix";
        packages.desktop = {
          imports = [ "${self}/packages/system/desktop.nix" ];
        };
        packages.dns = { imports = [ "${self}/packages/system/dns.nix" ]; };
        packages.keepass = {
          imports = [ "${self}/packages/system/keepass.nix" ];
        };
        packages.steam = { imports = [ "${self}/packages/system/steam.nix" ]; };
        packages.prometheus = {
          imports = [ "${self}/packages/prometheus.nix" ];
        };
      };
  };
}
