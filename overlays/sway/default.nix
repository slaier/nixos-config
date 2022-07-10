final: prev: {
  sway-unwrapped = prev.sway-unwrapped.overrideAttrs (_: prevAttrs:
    {
      patches = prevAttrs.patches ++ [
        ./0001-text_input-Implement-input-method-popups.patch
      ];
    });
}
