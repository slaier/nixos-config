{ lib, ... }:
{
  services.aria2 = {
    enable = true;
    openPorts = true;
    extraArguments = lib.concatStringsSep " " [
      "--continue=true"
      "--max-connection-per-server=8"
      "--min-split-size=1M"
      "--http-accept-gzip=true"
      "--seed-ratio=0.0"
      "--save-session=/var/lib/aria2/aria2.session"
      "--input-file=/var/lib/aria2/aria2.session"
      "--save-session-interval=5"
      "--force-save=true"
      "--bt-save-metadata=true"
      "--bt-load-saved-metadata=true"
      "--bt-detach-seed-only=true"
      "--bt-max-peers=0"
      ("--bt-tracker=" + (lib.concatStringsSep "," [
        "http://tracker.ipv6tracker.org:80/announce"
        "http://tracker.opentrackr.org:1337/announce"
        "https://tracker.tamersunion.org:443/announce"
        "udp://bt.ktrackers.com:6666/announce"
        "udp://exodus.desync.com:6969/announce"
        "udp://explodie.org:6969/announce"
        "udp://isk.richardsw.club:6969/announce"
        "udp://open.demonii.com:1337/announce"
        "udp://open.free-tracker.ga:6969/announce"
        "udp://open.stealth.si:80/announce"
        "udp://tracker.bittor.pw:1337/announce"
        "udp://tracker.moeking.me:6969/announce"
        "udp://tracker.publictracker.xyz:6969/announce"
        "udp://tracker.t-rb.org:6969/announce"
        "udp://tracker.therarbg.to:6969/announce"
        "udp://tracker.tiny-vps.com:6969/announce"
        "udp://tracker.torrent.eu.org:451/announce"
        "udp://tracker1.bt.moack.co.kr:80/announce"
        "udp://tracker1.myporn.club:9337/announce"
        "udp://tracker2.dler.org:80/announce"
      ]))
      "--https-proxy=http://127.0.0.1:7890"
    ];
  };
}
