{ ... }: {
  programs.fzf.enable = true;
  programs.fish = {
    enable = true;
    functions = {
      git-clone-test = ''
        set -l tempd (mktemp -d)
        timeout 30s git clone --bare https://github.com/jquery/jquery.git $tempd
        rm -rf $tempd
      '';
    };
    shellAliases = {
      nixexpr = ''curl -w "%{url_effective}\n" -I -L -s -S $URL -o /dev/null https://nixos.org/channels/nixos-22.05/nixexprs.tar.xz'';
    };
    loginShellInit = ''
      set TTY1 (tty)
      [ "$TTY1" = "/dev/tty1" ] && exec sway
    '';
  };
}
