{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    safeeyes
  ];
  environment.etc."sway/config.d/safeeyes.conf".text = ''
    exec --no-startup-id safeeyes
  '';
}
