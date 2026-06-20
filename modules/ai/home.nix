{
  config,
  lib,
  pkgs,
  ...
}:
let
  rtkMD = pkgs.runCommand "claude-rtk-md" { } ''
    mkdir -p $out
    cp "${pkgs.rtk.src}/hooks/claude/rtk-awareness.md" $out/CLAUDE.md
  '';

  mkShellApp =
    {
      package,
      name ? package.meta.mainProgram,
      runtimeEnv ? null,
      runtimeEnvFile ? null,
      flags ? "",
    }:
    pkgs.writeShellApplication {
      inherit name runtimeEnv;
      text =
        lib.optionalString (runtimeEnvFile != null) (
          lib.concatMapAttrsStringSep "" (name: value: ''
            ${name}="$(cat ${value})"
            export ${name}
          '') runtimeEnvFile
        )
        + ''
          exec ${lib.getExe package} ${flags} "$@"
        '';
    };
in
{
  home.packages = with pkgs; [
    rtk
    (mkShellApp {
      name = "summarize";
      package = pkgs.proxychains-ng;
      flags = "-q ${lib.getExe pkgs.summarize}";
      runtimeEnv = {
        SUMMARIZE_MODEL = "google/gemini-3.1-flash-lite";
      };
      runtimeEnvFile = {
        GEMINI_API_KEY = config.sops.secrets.summarize.path;
      };
    })
  ];
  sops.secrets.summarize = { };
  sops.secrets.tavily = { };
  sops.secrets.context7 = { };
  programs.mcp = {
    enable = true;
    servers =
      let
        mcp-remote =
          flags:
          "${lib.getExe (
            pkgs.writeShellApplication {
              name = "mcp-remote";
              runtimeInputs = [ pkgs.nodejs ];
              text = ''
                npx -y mcp-remote ${flags}
              '';
            }
          )}";
      in
      {
        tavily = {
          enabled = true;
          env.TAVILY_API_KEY.file = config.sops.secrets.tavily.path;
          command = mcp-remote ''"https://mcp.tavily.com/mcp/?tavilyApiKey=$TAVILY_API_KEY"'';
        };
        context7 = {
          enabled = true;
          env.CONTEXT7_API_KEY.file = config.sops.secrets.context7.path;
          command = mcp-remote ''https://mcp.context7.com/mcp --header "CONTEXT7_API_KEY: $CONTEXT7_API_KEY"'';
        };
      };
  };
  programs.claude-code = {
    enable = true;

    package = mkShellApp {
      package = pkgs.claude-code;
      flags = "--add-dir ${rtkMD}";
      runtimeEnv = {
        ANTHROPIC_BASE_URL = "http://127.0.0.1:3456";
        ANTHROPIC_AUTH_TOKEN = "dummy";
        ANTHROPIC_MODEL = "gemma-4-31b-it";
        ANTHROPIC_DEFAULT_HAIKU_MODEL = "gemma-4-31b-it";
        ANTHROPIC_DEFAULT_SONNET_MODEL = "gemma-4-31b-it";
        ANTHROPIC_DEFAULT_OPUS_MODEL = "gemma-4-31b-it";
        CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD = "1";
      };
    };

    configDir = "${config.xdg.configHome}/claude";

    enableMcpIntegration = true;

    skills = {
      summarize = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/openclaw/openclaw/refs/tags/v2026.6.8/skills/summarize/SKILL.md";
        hash = "sha256-ttm+D/R+ZGKAoP9AIDgj18o2kTqxvqJVdbLeSvs8wN8=";
      };
      playwright-cli = "${pkgs.playwright-cli}/lib/node_modules/@playwright/cli/skills/playwright-cli";
    };
    plugins = [
      (pkgs.fetchFromGitHub {
        owner = "obra";
        repo = "superpowers";
        rev = "v6.0.3";
        hash = "sha256-+lT2a/qq0SF4k0PgnEDKiuidVlZX2p0vEso4d/5T1os=";
      })
    ];

    settings = {
      statusLine = {
        type = "command";
        command = "${lib.getExe pkgs.ccometixline}";
      };
      hooks = {
        PreToolUse = [
          {
            matcher = "Bash";
            hooks = [
              {
                type = "command";
                command = "rtk hook claude";
              }
            ];
          }
        ];
      };

      # Best-practice security boundaries:
      # - Auto-allow read-only Git commands
      # - Require explicit confirmation for commits, pushes, and generic Bash commands
      # - Strictly deny access to sensitive secrets and environment files
      permissions = {
        allow = [
          "Bash(git diff:*)"
          "Bash(git status:*)"
          "Bash(git log:*)"
        ];
        ask = [
          "Bash(git push:*)"
          "Bash(git commit:*)"
          "Bash(*)"
          "Edit"
          "WebFetch"
          "Write"
        ];
        deny = [
          "WebSearch"
          "Read(./.env)"
          "Read(./secrets/**)"
          "Read(**/*.pem)"
          "Read(**/*.key)"
        ];
        defaultMode = "acceptEdits";
        disableBypassPermissionsMode = "disable";
      };
    };
  };
}
