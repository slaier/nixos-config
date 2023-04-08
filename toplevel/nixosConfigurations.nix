{ self, super, root, lib, inputs }:
with lib;
flip mapAttrs super.hosts (hostName: host:
let
  inherit (host) system;
  inherit (inputs) impermanence darkmatter-grub-theme home-manager nur nixpkgs;
  nurModules = import nur { nurpkgs = import nixpkgs { inherit system; }; };
in
nixosSystem {
  inherit system;
  modules = [
    impermanence.nixosModules.impermanence
    darkmatter-grub-theme.nixosModule
    home-manager.nixosModules.home-manager
    nur.nixosModules.nur
    nurModules.repos.slaier.modules.clash
    super.nix
    host.default
    host.hardware-configuration
    { networking.hostName = hostName; }
  ];
})
