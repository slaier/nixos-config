{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/22.05";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur-slaier.url = "github:slaier/nur-packages";
    nur-slaier.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nur-slaier }: {

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

    nixosConfigurations.vbox = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          imports = [
            ./hosts/vbox
            ./users
          ];
          nixpkgs.config.packageOverrides = pkgs: {
            nur-slaier = nur-slaier.packages.x86_64-linux;
          };
          nix.registry.sys.flake = nixpkgs;
        })

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            hm-path = ./hm;
          };
          home-manager.users.nixos = import ./users/nixos/hm.nix;
        }
      ];
    };
  };
}
