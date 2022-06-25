{ config, pkgs, lib, ... }: {
  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
  environment.pathsToLink = [ "/libexec" ];
  environment.etc."i3status.toml".source = ./i3status.toml;
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
      extraPackages = with pkgs; with nur.repos.xddxdd; [
        alacritty
        dunst
        gimp
        gnome.gnome-screenshot
        i3lock-fancy
        i3status-rust
        keepassxc
        libreoffice-fresh
        networkmanagerapplet
        okular
        picom
        pavucontrol
        qbittorrent-enhanced-edition
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

