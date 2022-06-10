self: super: {
  fcitx5 = super.fcitx5.overrideAttrs (_: prev:
    assert (prev.version == "5.0.15") && (!self.lib.hasAttrByPath [ "patches" ] prev);
    {
      patches = [
        ./fix_font_dpi_setup_for_xcbmenu.patch
      ];
    });
}

