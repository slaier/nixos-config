{ inputs, modules, ... }:
let
  local-modules = with modules; [
    nix.default
  ];
in
inputs.nixos-generators.nixosGenerate {
  system = "aarch64-linux";
  modules = local-modules ++ [
    {
      _module.args = {
        inherit inputs;
      };
    }
    ({ lib, ... }: {
      options.sops = lib.mkSinkUndeclaredOptions { };
    })
    ({ pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        ethtool
        inputs.disko.packages."aarch64-linux".disko
      ];
    })
  ];
  format = "sd-aarch64-installer";
}
