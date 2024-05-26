{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    crane.url = "github:ipetkov/crane/v0.15.1";
  };

  outputs = { self, nixpkgs, home-manager, crane, ... }:
    with import nixpkgs { system = "x86_64-linux"; }; {

      lib = {

        # get all nixos modules required by the homemanager config
        getHomeManagerDependencies = homeManagerModules:
          (pkgs.lib.evalModules {
            modules = homeManagerModules ++ [{ _module.check = false; }];
          }).config.requiredSystemModules;

      };

      nixosModules = with pkgs.lib; {

        default = { config, ... }: {
          imports = [
            "${nixpkgs}/nixos/modules/profiles/minimal.nix"
            "${self}/default.nix"
          ];
        };

        packages = {
          desktop = { imports = [ "${self}/packages/system/desktop.nix" ]; };
          dns = { imports = [ "${self}/packages/system/dns.nix" ]; };
          keepass = { imports = [ "${self}/packages/system/keepass.nix" ]; };
          steam = { imports = [ "${self}/packages/system/steam.nix" ]; };
          prometheus = { imports = [ "${self}/packages/prometheus.nix" ]; };
        };

      };
    };
}
