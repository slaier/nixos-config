{ ... }: {
  programs.fzf.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      thefuck --alias | source
    '';
    shellAliases = {
      nixexpr = ''curl -w "%{url_effective}\n" -I -L -s -S $URL -o /dev/null https://nixos.org/channels/nixos-22.05/nixexprs.tar.xz'';
    };
  };
}

