{
  makeNoProxyWrapper = { name, pkg, symlinkJoin, makeWrapper }:
    symlinkJoin
      {
        inherit name;
        paths = [ pkg ];
        buildInputs = [ makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/${name} \
            --unset all_proxy          \
            --unset https_proxy        \
            --unset http_proxy         \
            --unset ftp_proxy          \
            --unset rsync_proxy        \
            --unset no_proxy           \
            --unset RES_OPTIONS
        '';
      };
}
