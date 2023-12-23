{ name, homeModules ? [ ], pswdHash, sshKeys, userConfig, pkgs }: {
  inherit name homeModules userConfig;
  systemConfig = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "networkmanager" ];
    shell = pkgs.nushellFull;
    hashedPassword = pswdHash;
    openssh.authorizedKeys.keys = sshKeys;
  };
}
