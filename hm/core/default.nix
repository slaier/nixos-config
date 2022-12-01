{ ... }: {
  imports = [
    ./fish.nix
    ./git.nix
    ./neovim.nix
  ];
  home.stateVersion = "22.11";
}
