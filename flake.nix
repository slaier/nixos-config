{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    latest.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    nur-slaier.url = "github:slaier/nur-packages";
    nur-slaier.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, latest, home-manager, nur, nur-slaier }:
    let
      inherit (nixpkgs.lib.attrsets) genAttrs mapAttrs attrValues;

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
        };
      };
      forAllHosts = f: mapAttrs f hosts;
    in
    {
      formatter = forAllSystems (system:
        (let pkgs = import nixpkgs { inherit system; }; in pkgs.nixpkgs-fmt)
      );
      nixosConfigurations = forAllHosts (host: { system, host-module }: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ pkgs, ... }: {
            imports = [
              host-module
              ./system
            ];
            nixpkgs.overlays = [
              nur.overlay
            ];
            nixpkgs.config.packageOverrides = (
              let pkgs-latest = import latest { inherit system; }; in
              pkgs: {
                nur-slaier = nur-slaier.packages.${system};
                fcitx5 = pkgs-latest.fcitx5;
              }
            );
            nix.registry.sys.flake = nixpkgs;
          })

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.nixos = import ./hm;
            };
          }
        ];
      });
    };
}
