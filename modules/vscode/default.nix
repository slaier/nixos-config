{ pkgs, ... }:
let
  models = pkgs.linkFarm "models" [
    {
      name = "phi4-mini";
      path = pkgs.fetchurl {
        name = "Phi-4-mini-instruct.Q4_K_M.gguf";
        url = "https://huggingface.co/MaziyarPanahi/Phi-4-mini-instruct-GGUF/resolve/main/Phi-4-mini-instruct.Q4_K_M.gguf?download=true";
        sha256 = "sha256-hVz2D3+BCHE/sOc5yrcv2dv2xtQWC9f/A1gULHSuMoc=";
      };
    }
  ];
in
{
  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp.override {
      vulkanSupport = true;
    };
    extraFlags = [
      "-ngl"
      "99"
    ];
    model = "${models}/phi4-mini";
  };
  systemd.services.llama-cpp = {
    environment = {
      HOME = "/var/lib/llama-cpp";
    };
    serviceConfig = {
      StateDirectory = [ "llama-cpp" ];
      WorkingDirectory = [ "/var/lib/llama-cpp" ];
    };
  };
  environment.etc."systemd/system-sleep/suspend-llama.sh".source = pkgs.writeShellScriptBin "suspend-llama.sh" ''
    #!/bin/sh

    case "$1" in
        pre)
            systemctl stop llama-cpp.service
            ;;
        post)
            systemctl start llama-cpp.service
            ;;
    esac
  '';
}
