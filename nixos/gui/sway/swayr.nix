{ lib, pkgs, ... }:
''
  [menu]
  executable = '${lib.getExe pkgs.rofi-wayland}'
  args = [
      '-dmenu',
      '-markup',
      '-i',
      '-markup-rows',
      '-mesg={prompt}',
      '-show-icons',
  ]

  [format]
  output_format = '{indent}<b>Output {name}</b>    <span alpha=\"20000\">({id})</span>'
  workspace_format = '{indent}<b>Workspace {name} [{layout}]</b>    <span alpha="20000">({id})</span>'
  container_format = '{indent}<b>Container [{layout}]</b> on workspace {workspace_name} <i>{marks}</i>    <span alpha="20000">({id})</span>'
  window_format = "{urgency_start}<b>“{title}”</b>{urgency_end} — <i>{app_name}</i> on workspace {workspace_name}   <span alpha='20000'>({id})</span>\u0000icon\u001f{app_icon}"
  indent = '    '
  urgency_start = '<span background="darkred" foreground="yellow">'
  urgency_end = '</span>'
  html_escape = true
  icon_dirs = [
      '/run/current-system/sw/share/icons/hicolor/scalable/apps',
      '/run/current-system/sw/share/icons/hicolor/48x48/apps',
      '/run/current-system/sw/share/pixmaps',
      '~/.nix-profile/share/icons/hicolor/scalable/apps',
      '~/.nix-profile/share/icons/hicolor/48x48/apps',
      '~/.nix-profile/share/pixmaps',
      '/usr/share/icons/hicolor/scalable/apps',
      '/usr/share/icons/hicolor/64x64/apps',
      '/usr/share/icons/hicolor/48x48/apps',
      '/usr/share/icons/Adwaita/64x64/apps',
      '/usr/share/icons/Adwaita/48x48/apps',
      '/usr/share/pixmaps',
  ]

  [layout]
  auto_tile = false
  auto_tile_min_window_width_per_output_width = [
      [1024, 500],
      [1280, 600],
      [1400, 680],
      [1440, 700],
      [1600, 780],
      [1920, 920],
      [2560, 1000],
      [3440, 1000],
      [4096, 1200],
  ]

  [focus]
  lockin_delay = 750

  [misc]
  auto_nop_delay = 3000
  seq_inhibit = false
''
