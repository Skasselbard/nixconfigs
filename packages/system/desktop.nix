{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [ gnome-tweaks ];
  services.printing.enable = lib.mkDefault true;
  networking.networkmanager.enable = lib.mkDefault true;
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "de";
    xkb.variant = "nodeadkeys";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
}
