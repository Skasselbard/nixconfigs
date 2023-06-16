{config, pkgs, ... }:
with pkgs;{ 
  imports = [
    ./physical_machines/boot.nix
    ./physical_machines/partitioning.nix
    ../.
  ];
  users.extraUsers = 
    {root.shell = zsh;} //
    listToAttrs (map (elem: {
      name = elem;
      value = {
        shell = zsh;
      };
    }) config.osUsers);
}