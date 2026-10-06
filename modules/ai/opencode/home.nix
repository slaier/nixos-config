{ pkgs, ... }:
let
  i-have-adhd = pkgs.fetchFromGitHub {
    owner = "ayghri";
    repo = "i-have-adhd";
    rev = "b15d0be58f55b33972ba3e39709e0e5208ef30cb";
    hash = "sha256-wnD5crIal23Vtk6GReG2vCkjDuhrpmhWXvrNUq5mZfE=";
  };
  mattpocock-skills = pkgs.fetchFromGitHub {
    owner = "mattpocock";
    repo = "skills";
    rev = "v1.2.3";
    hash = "sha256-I/EXHGW92nXz6JCLp8SKGgzXrbbUTkLAfxv8bc/ThwQ=";
  };
in
{
  programs.opencode = {
    enable = true;
    skills.skill-creator = ./skills/skill-creator;
    skills.grilling = "${mattpocock-skills}/skills/productivity/grilling";
    skills.fix-mpv-subtitle-entities = ./skills/fix-mpv-subtitle-entities;
    skills.find-flake-input = ./skills/find-flake-input;
    extraPackages = with pkgs; [ rtk ];
    settings = {
      plugin = [
        "${pkgs.rtk.src}/hooks/opencode/rtk.ts"
        "@dietrichgebert/ponytail"
        "${i-have-adhd}/.opencode/plugins/i-have-adhd.mjs"
      ];
      provider = {
        "llama.cpp" = {
          npm = "@ai-sdk/openai-compatible";
          name = "llama-server (local)";
          options.baseURL = "http://127.0.0.1:8080/v1";
          models = {
            "preset/Ornith-1.5-35B-A3B" = {
              name = "Ornith-1.5-35B-A3B (local)";
              limit = {
                context = 131072;
                output = 65536;
              };
              attachment = true;
              family = "qwen";
              modalities = {
                input = [
                  "text"
                  "image"
                  "video"
                ];
                output = [ "text" ];
              };
              open_weights = true;
              reasoning = true;
              reasoning_options = [ ];
              structured_output = true;
              temperature = true;
              tool_call = true;
            };
          };
        };
      };
      permission = {
        read = {
          "secrets/**" = "deny";
        };
      };
    };
  };
}
