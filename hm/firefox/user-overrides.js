// begin
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("svg.context-properties.content.enabled", true);
user_pref("network.trr.mode", 3); // enable TRR (without System fallback)
user_pref("network.dns.skipTRR-when-parental-control-enabled", false);
user_pref("network.security.esni.enabled", true);
user_pref("browser.contentblocking.category", "standard");
/*** [SECTION 2800]: SHUTDOWN & SANITIZING ***/
// 3: The cookie lasts for the number of days specified by network.cookie.lifetime.days(Default: 90). 
user_pref("network.cookie.lifetimePolicy", 3);
user_pref("privacy.clearOnShutdown.history", false);
// end
