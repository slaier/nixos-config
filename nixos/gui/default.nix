{ pkgs, ... }: {
  imports = [
    ./i3
    ./sway
  ];

  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
    };
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  environment.systemPackages = with pkgs; with nur.repos.xddxdd; [
    alacritty
    keepassxc
    okular
    pavucontrol
    qbittorrent-enhanced-edition
    quiterss
    spotify
    stretchly
    tdesktop
    vlc
  ];
}
