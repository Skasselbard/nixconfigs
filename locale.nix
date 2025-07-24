{ pkgs, ... }:
{

  console.packages = [ pkgs.terminus_font ];
  console.font = "ter-v16b.psf.gz";
  console.keyMap = "de-latin1-nodeadkeys";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_COLLATE = "de_DE.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
      # LC_ALL = "en_US.UTF-8";
    };
  };
  time.timeZone = "Europe/Berlin";
}
