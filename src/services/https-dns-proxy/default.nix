{
  services.https-dns-proxy = {
    enable = true;
    provider.kind = "google";
  };
  systemd.services.https-dns-proxy.environment = {
    http_proxy = "http://n1.lan:7890";
    https_proxy = "http://n1.lan:7890";
  };
}
