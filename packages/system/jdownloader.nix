{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.flatpak.enable = true;

  # Make sure flathub is added as a remote
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # make 'jdownloader' command available for execution
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "jdownloader" ''
      if ! ${pkgs.flatpak}/bin/flatpak list --app | grep -q org.jdownloader.JDownloader; then
        echo "JDownloader not found — installing…"
        ${pkgs.flatpak}/bin/flatpak install -y --noninteractive flathub org.jdownloader.JDownloader
      fi
      ${pkgs.flatpak}/bin/flatpak run org.jdownloader.JDownloader "$@"
    '')
  ];

}
