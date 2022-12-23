{ ... }: {
  imports = [
    ./fish.nix
    ./git.nix
    ./neovim.nix
  ];
  xdg.enable = true;
  home.stateVersion = "22.11";
}
