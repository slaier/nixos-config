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
      d = "diff";
      dc = "diff --cached";
      ds = "diff --staged";
      r = "restore";
      rs = "restore --staged";
      st = "status -sb";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
  };
}

