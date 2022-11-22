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

  environment.systemPackages = with pkgs; [
    curl
    git
    neovim
    wget
  ];
}
