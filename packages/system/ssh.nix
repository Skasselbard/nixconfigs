{ config, lib, ... }:
with lib; {
  services.openssh.enable = mkDefault true;
  services.openssh.settings.PermitRootLogin = mkDefault "prohibit-password";
  services.openssh.settings.PasswordAuthentication = mkDefault false;
  networking.firewall.allowedTCPPorts = config.services.openssh.ports;
}
