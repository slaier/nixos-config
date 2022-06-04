{ ... }: {
  programs.git = {
    enable = true;
    difftastic = {
      enable = true;
      background = "dark";
    };
    extraConfig = {
      core.editor = "vim";
      credential.helper = "store";
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      merge.ff = "only";
      pull.rebase = true;
    };

    ignores = [
      ".ccls-cache/"
    ];

    userEmail = "30682486+Slaier@users.noreply.github.com";
    userName = "Slaier";

    aliases = {
      st = "status -sb";
    };
  };
}

