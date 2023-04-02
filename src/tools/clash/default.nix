{ config, pkgs, lib, ... }: {
  slaier.services.clash = with config.nur.repos.slaier; {
    enable = true;
    dashboard.path = yacd;
    geoip.path = "${clash-geoip}/etc/clash/Country.mmdb";
    beforeUnits = lib.mkIf (config.services.https-dns-proxy.enable) [ "https-dns-proxy.service" ];
  };

  networking.firewall.allowedTCPPorts = [
    3333 # yacd
    7890 # http_proxy
    9090 # clashctl
  ];
}
