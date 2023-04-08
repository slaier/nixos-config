{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true;

  environment.etc."sway/config.d/blueman.conf".text = ''
    exec --no-startup-id ${pkgs.blueman}/bin/blueman-applet
  '';
}
