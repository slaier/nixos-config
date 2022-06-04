{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/22.05";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }: {

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

    nixosConfigurations.vbox = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          imports = [
            ./hosts/vbox
            ./users
          ];
          nix.registry.sys.flake = nixpkgs;
        })

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            hm-path = ./hm;
            packages = (import ./pkgs { pkgs = import nixpkgs { inherit system; }; });
          };
          home-manager.users.nixos = import ./users/nixos/hm.nix;
        }
      ];
    };
  };
}
