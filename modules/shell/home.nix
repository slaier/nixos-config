{ config, pkgs, ... }:
{
  programs.fzf.enable = true;
  programs.fish = {
    enable = true;
    shellAliases = {
      noproxy = "env -u http_proxy -u https_proxy -u ftp_proxy -u rsync_proxy -u all_proxy ";
      listen = "sudo lsof -nP -i 4 -sTCP:LISTEN";
      cn = "${pkgs.nur.repos.MiyakoMeow.continue-cli}/bin/cn --config ${config.xdg.configHome}/continue/config.yaml";
    };
  };
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      theme = "Monokai Classic";
      notify-on-command-finish = "unfocused";
      notify-on-command-finish-action = "notify";
    };
  };
}
