{ pkgs, config, ... }: {
  imports = [
    ./sway
  ];

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FantasqueSansMono"
        ];
      })
      noto-fonts-emoji
      source-han-mono
      source-han-sans
      source-han-serif
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "FantasqueSansMono Nerd Font Mono" "Source Han Serif SC" ];
        sansSerif = [ "FantasqueSansMono Nerd Font Mono" "Source Han Sans SC" ];
        monospace = [ "FantasqueSansMono Nerd Font Mono" "Source Han Mono SC" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.enableRimeData = true;
    fcitx5.addons = with pkgs; with nur.repos.xddxdd; [
      fcitx5-chinese-addons
      fcitx5-gtk
      fcitx5-rime
      libsForQt5.fcitx5-qt
      rime-aurora-pinyin
      rime-data
      rime-dict
      rime-moegirl
      rime-zhwiki
    ];
  };
  environment.variables = {
    QT_PLUGIN_PATH = [ "${config.i18n.inputMethod.package}/${pkgs.qt6.qtbase.qtPluginPrefix}" ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
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
    xdg-utils
  ];
}
