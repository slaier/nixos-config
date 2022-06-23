{ config, pkgs, lib, ... }: {
  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
  environment.pathsToLink = [ "/libexec" ];
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      defaultSession = "none+i3";
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        alacritty
        dunst
        gimp
        gnome.gnome-screenshot
        i3blocks
        i3lock-fancy
        keepassxc
        libreoffice-fresh
        networkmanagerapplet
        okular
        picom
        pavucontrol
        quiterss
        rofi
        spotify
        stretchly
        tdesktop
        vlc
        xautolock
      ];
      configFile = ./config;
    };
  };
}

