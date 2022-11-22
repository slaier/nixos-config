{ pkgs, ... }: {
  programs.fish.enable = true;

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [
      "adbusers"
      "aria2"
      "docker"
      "vboxusers"
      "wheel"
    ];
    shell = pkgs.fish;
  };
}
