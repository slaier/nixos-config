{ super, lib, inputs, hosts, src, ... }:
{
  meta = {
    nixpkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
    };
    specialArgs = {
      inherit src inputs;
      inherit (super) overlay;
    };
  };
  defaults = { name, config, pkgs, ... }: {
    imports = with inputs; [
      impermanence.nixosModules.impermanence
      darkmatter-grub-theme.nixosModule
      home-manager.nixosModules.home-manager
      nur.nixosModules.nur
      hosts.${name}.hardware-configuration
    ];

    networking.hostName = name;
    deployment.targetHost = name + ".local";
    deployment.allowLocalDeployment = true;
  };
} // (lib.mapAttrs (n: v: v.default) hosts)
