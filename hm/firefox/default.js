// begin
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("svg.context-properties.content.enabled", true);
/*** [SECTION 0700]: DNS / DoH / PROXY / SOCKS / IPv6 ***/
user_pref("network.trr.mode", 3); // enable TRR (without System fallback)
user_pref("network.dns.skipTRR-when-parental-control-enabled", false);
user_pref("network.security.esni.enabled", true);
user_pref("network.trr.uri", "https://dns.google/dns-query");
user_pref("network.trr.bootstrapAddress", "8.8.8.8");
user_pref("network.trr.blacklist-duration", 15);
user_pref("network.trr.request_timeout_mode_trronly_ms", 1500);
user_pref("network.trr.wait-for-A-and-AAAA", false);
user_pref("network.proxy.no_proxies_on", "localhost,127.0.0.1,192.168.0.0/16");
/*** [SECTION 2700]: ETP (ENHANCED TRACKING PROTECTION) ***/
user_pref("browser.contentblocking.category", "standard");
/*** [SECTION 2800]: SHUTDOWN & SANITIZING ***/
user_pref("privacy.clearOnShutdown.cookies", false);
user_pref("privacy.clearOnShutdown.history", false);
// end
