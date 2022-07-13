final: prev: {
  waybar = prev.waybar.overrideAttrs (_: prevAttrs:
    assert (prevAttrs.version == "0.9.12") && (!prev.lib.hasAttrByPath [ "patches" ] prevAttrs);
    {
      patches = [
        ./fix_clock.patch
      ];
    });
}
