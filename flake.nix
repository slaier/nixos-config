{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    nur-slaier.url = "github:slaier/nur-packages";
    nur-slaier.inputs.nixos.follows = "nixpkgs";

    indexyz.url = "github:X01A/nixos";
    indexyz.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nur, nur-slaier, indexyz }:
    let
      inherit (nixpkgs.lib.attrsets) genAttrs mapAttrs attrValues mapAttrsToList;

      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
      forAllSystems = f: genAttrs systems (system: f system);
      hosts = {
        vbox = {
          system = "x86_64-linux";
          host-module = ./hosts/vbox;
          users.nixos = import ./hosts/vbox/hm.nix;
        };
      };
      forAllHosts = f: mapAttrs f hosts;
    in
    {
      formatter = forAllSystems (system:
        (let pkgs = import nixpkgs { inherit system; }; in pkgs.nixpkgs-fmt)
      );
      overlays = mapAttrs (name: path: import path) (import ./overlays);
      nixosConfigurations = forAllHosts (_: { system, host-module, users }: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ pkgs, ... }: {
            imports = [
              ./nixos
              host-module
            ];
            nixpkgs.overlays = [
              nur.overlay
            ] ++ (mapAttrsToList (_: path: import path) (import ./overlays));
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.packageOverrides = pkgs: {
              nur-slaier = nur-slaier.packages.${system};
              indexyz = indexyz.legacyPackages.${system};
            };
            nix.registry.sys.flake = nixpkgs;
          })

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              inherit users;
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                ./hm
              ];
            };
          }
        ];
      });
    };
}
