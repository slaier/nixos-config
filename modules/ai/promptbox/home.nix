{
  config,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.promptbox ];

  sops.secrets.gemini_api_key = { };

  sops.templates."promptbox.env" = {
    content = ''
      GEMINI_API_KEY=${config.sops.placeholder.gemini_api_key}
    '';
    path = "${config.xdg.configHome}/promptbox/.env";
  };

  xdg.configFile."promptbox/promptbox.toml".source = pkgs.writers.writeTOML "promptbox.toml" {
    model = {
      model = {
        model = "gemini-3.5-flash-lite";
        host = "google";
      };
      context = {
        limit = 1048576;
        reserve_output = 65536;
        trim_args = [ ];
      };
    };
    host.google = {
      endpoint = "https://generativelanguage.googleapis.com/v1beta/openai";
      protocol = "openai";
      limit_context_length = false;
      api_key = "GEMINI_API_KEY";
      send_app_id = false;
    };
  };
}
