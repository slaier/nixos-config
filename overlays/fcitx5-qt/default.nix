final: prev: {
  libsForQt6.fcitx5-qt = prev.libsForQt5.fcitx5-qt.overrideAttrs (_: prevAttrs:
    {
      preConfigure = ''
        substituteInPlace qt5/platforminputcontext/CMakeLists.txt \
          --replace \$"{CMAKE_INSTALL_QT5PLUGINDIR}" $out/${prev.libsForQt5.qt5.qtbase.qtPluginPrefix}
        substituteInPlace qt6/platforminputcontext/CMakeLists.txt \
          --replace \$"{CMAKE_INSTALL_QT6PLUGINDIR}" $out/${prev.qt6.qtbase.qtPluginPrefix}
      '';

      cmakeFlags = [
        # adding qt6 to buildInputs would result in error: detected mismatched Qt dependencies
        "-DCMAKE_PREFIX_PATH=${prev.qt6.qtbase.dev}"
        "-DENABLE_QT4=0"
        "-DENABLE_QT6=1"
      ];
    });
}
