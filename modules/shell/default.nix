{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    svc-ports
  ];

  programs.fish.enable = true;
  users.users.nixos.shell = pkgs.fish;
}
