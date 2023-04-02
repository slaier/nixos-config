{ src, ... }:
{
  nixos = {
    imports = map (x: x.home) (
      (with src; [
        common
        applications.firefox
        applications.vscode
        libraries.gtk
      ]) ++
      (with src.tools; [
        fcitx5
        fish
        git
        neovim
      ])
    );
  };
}
