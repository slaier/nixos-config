final: prev: {
  fcitx5 = prev.fcitx5.overrideAttrs (_: prevAttrs:
    assert (prevAttrs.version == "5.0.15") && (!prev.lib.hasAttrByPath [ "patches" ] prevAttrs);
    {
      patches = [
        ./fix_font_dpi_setup_for_xcbmenu.patch
      ];
    });
}

