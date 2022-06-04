{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/22.05";
  };

  outputs = { self, nixpkgs }: {

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

    nixosConfigurations.vbox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          imports = [
            ./hosts/vbox
            ./users
          ];
          nix.registry.sys.flake = nixpkgs;
        })
      ];
    };

  };
}
