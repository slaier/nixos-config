{ config, pkgs, lib, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = (
      with pkgs.vscode-extensions; with pkgs.nur.repos.slaier; [
        eamodio.gitlens
        jnoortheen.nix-ide
        ms-vscode-remote.remote-ssh
        redhat.vscode-yaml
        shardulm94.trailing-spaces
        tamasfe.even-better-toml
        tyriar.sort-lines

        vscode-extension-ms-vscode-remote-remote-containers
        vscode-extension-vscode-icons-team-vscode-icons
      ]
    );
    userSettings = {
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = "active";
      "editor.formatOnPaste" = true;
      "editor.formatOnType" = true;
      "editor.minimap.enabled" = false;
      "editor.renderWhitespace" = "all";
      "editor.rulers" = [ 80 120 ];
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "search.collapseResults" = "auto";
      "telemetry.telemetryLevel" = "off";
      "terminal.integrated.copyOnSelection" = true;
      "update.mode" = "none";
      "workbench.colorTheme" = "Monokai";
      "workbench.commandPalette.preserveInput" = true;
      "workbench.editor.enablePreviewFromCodeNavigation" = true;
      "workbench.editorAssociations" = {
        "*.ipynb" = "jupyter.notebook.ipynb";
      };
      "workbench.iconTheme" = "vscode-icons";

      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.rnix-lsp}/bin/rnix-lsp";
      "remote.containers.dockerPath" = "podman";
    };
  };
}
