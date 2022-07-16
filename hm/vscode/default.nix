{ config, pkgs, lib, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs;
    extensions = (
      with pkgs.vscode-extensions; with pkgs.nur.repos.slaier; [
        eamodio.gitlens
        jnoortheen.nix-ide
        matklad.rust-analyzer
        ms-python.python
        ms-vscode-remote.remote-ssh
        ms-vscode.cpptools
        redhat.vscode-yaml
        tamasfe.even-better-toml
        tyriar.sort-lines

        vscode-extension-ccls-project-ccls
        vscode-extension-timonwong-shellcheck
        vscode-extension-shardulm94-trailing-spaces
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
      "files.exclude" = {
        "**/.git" = true;
        "**/.svn" = true;
        "**/.hg" = true;
        "**/CVS" = true;
        "**/.DS_Store" = true;
        "**/.ccls-cache" = true;
      };
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

      "ccls.launch.command" = "${pkgs.ccls}/bin/ccls";
      "ccls.highlight.function.face" = [ "enabled" ];
      "ccls.highlight.type.face" = [ "enabled" ];
      "ccls.highlight.variable.face" = [ "enabled" ];
      "C_Cpp.autocomplete" = "Disabled";
      "C_Cpp.formatting" = "Disabled";
      "C_Cpp.errorSquiggles" = "Disabled";
      "C_Cpp.intelliSenseEngine" = "Disabled";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.rnix-lsp}/bin/rnix-lsp";
      "shellcheck.executablePath" = "${pkgs.shellcheck}/bin/shellcheck";
    };
  };
}
