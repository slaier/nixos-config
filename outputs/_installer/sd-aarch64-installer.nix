{ inputs, ... }:
inputs.nixos-generators.nixosGenerate {
  system = "aarch64-linux";
  modules = [
    ({ pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        ethtool
        inputs.disko.packages."aarch64-linux".disko
      ];
    })
  ];
  format = "sd-aarch64-installer";
}
