{ pkgs, ... }: {
  nix.settings = {
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://slaier.cachix.org"
    ];
    trusted-public-keys = [
      "slaier.cachix.org-1:NyXPOqlxuGWgyn0ApNHMopkbix3QjMUAcR+JOjjxLtU="
    ];
    auto-optimise-store = true;
    flake-registry = "/etc/nix/registry.json";
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.persistence."/nix/persist" = {
    directories = [
      "/etc"
      "/var/log/journal"
    ];
    users.nixos = {
      directories = [
        ".cache"
        ".config"
        ".local"
        ".mozilla"
        ".nali"
        ".ssh"
        "repos"
      ];
      files = [
        ".git-credentials"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    neovim
    wget
  ];
}
