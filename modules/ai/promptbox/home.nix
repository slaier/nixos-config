{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.promptbox ];

  xdg.configFile."promptbox/promptbox.toml".source = pkgs.writers.writeTOML "promptbox.toml" {
    templates = [ ./templates ];
    model = {
      model = {
        model = "InternScience/Sage-A1.5";
        host = "ggml";
      };
      context = {
        limit = 131072;
        reserve_output = 8192;
        trim_args = [ ];
      };
    };
    host.ggml = {
      endpoint = "http://127.0.0.1:8080/v1";
      protocol = "openai";
      limit_context_length = false;
      send_app_id = false;
    };
  };

  programs.fish.functions = {
    aic = ''
      begin
        git diff --cached --name-status
        git diff --cached -O (git diff --cached --name-only --diff-filter ad | psub)
      end | proxychains4 -q promptbox run commit | xargs -p -r -0 -I{} git commit -m '{}'
    '';

    tzh = "xargs -p -r -0 proxychains4 -q promptbox run translate --target_lang zh";
    ten = "xargs -p -r -0 proxychains4 -q promptbox run translate --target_lang en";
  };
}
