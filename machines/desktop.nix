{ ... }: {
  imports = [
    ../default.nix
    ../users
    # ../users/home-manager.nix
    ../packages
    ../packages/gnome.nix
    ../packages/desktop.nix
  ];
}
