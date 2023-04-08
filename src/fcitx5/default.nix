{ config, pkgs, ... }: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.enableRimeData = true;
    fcitx5.addons = with pkgs; with config.nur.repos.xddxdd; [
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
  environment.etc."sway/config.d/fcitx5.conf".text = ''
    exec --no-startup-id fcitx5 -d -r
  '';
}
