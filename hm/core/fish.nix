{ config, pkgs, ... }: {
  programs.fzf.enable = true;
  programs.fish = {
    enable = true;
  };
  programs.nix-index.enable = true;
  home.file."${config.xdg.cacheHome}/nix-index/files".source = pkgs.nix-index-database;
}
