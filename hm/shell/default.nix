{ ... }: {
  programs.fzf.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      thefuck --alias | source
    '';
  };
}

