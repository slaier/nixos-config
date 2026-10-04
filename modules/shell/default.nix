{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    svc-ports
  ];

  programs.fish.enable = true;
  programs.yazi.enable = true;
  users.users.nixos.shell = pkgs.fish;
}
