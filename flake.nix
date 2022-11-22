{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-channel.url = "https://releases.nixos.org/nixos/22.05/nixos-22.05.3954.4f09cfce9c1/nixexprs.tar.xz";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    impermanence.url = "github:nix-community/impermanence";

    indexyz.url = "github:X01A/nixos";
    indexyz.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-channel, home-manager, nur, impermanence, indexyz }:
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
        pc = {
          system = "x86_64-linux";
          host-module = ./hosts/pc;
          users.nixos = import ./hm/gui;
        };
        n1 = {
          system = "aarch64-linux";
          host-module = ./hosts/phicomm-n1;
          users.nixos = { };
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
              impermanence.nixosModules.impermanence
              ./nixos
              host-module
            ];
            nixpkgs.overlays = [
              nur.overlay
            ] ++ (mapAttrsToList (_: path: import path) (import ./overlays));
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.packageOverrides = pkgs: {
              indexyz = indexyz.legacyPackages.${system};
            };
            nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
            nix.registry.nixpkgs.flake = nixpkgs;
            programs.command-not-found.dbPath = "${nixpkgs-channel}/programs.sqlite";
          })

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              inherit users;
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                ./hm/core
              ];
            };
          }
        ];
      });
    };
}
