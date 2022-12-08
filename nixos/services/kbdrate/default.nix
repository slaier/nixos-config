{ pkgs, ... }: {
  systemd.services.kbdrate = {
    description = "Keyboard repeat rate in tty.";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      StandardInput = "tty";
      StandardOutput = "tty";
      ExecStart = "${pkgs.kbd}/bin/kbdrate --silent --delay 250 --rate 30";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
