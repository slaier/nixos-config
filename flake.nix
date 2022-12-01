{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.utils.follows = "flake-utils";

    nur.url = "github:nix-community/NUR";

    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, nur, impermanence }:
    let
      inherit (nixpkgs.lib) composeManyExtensions attrValues flip mapAttrs;
      inherit (flake-utils.lib) eachDefaultSystem;

      hosts = {
        pc = {
          system = "x86_64-linux";
          nixosModule = ./hosts/pc;
          users.nixos = import ./hosts/pc/home.nix;
        };
        n1 = {
          system = "aarch64-linux";
          nixosModule = ./hosts/phicomm-n1;
          users.nixos = import ./hosts/phicomm-n1/home.nix;
        };
      };
    in
    (eachDefaultSystem (system: {
      formatter = (import nixpkgs { inherit system; }).nixpkgs-fmt;
    })) //
    {
      overlay = composeManyExtensions (attrValues self.overlays);
      overlays = mapAttrs (_n: import) (import ./overlays);
      nixosConfigurations = flip mapAttrs hosts (_n: host:
        let
          inherit (host) system;

          nurWithPkgs = pkgs: import nur {
            inherit pkgs;
            nurpkgs = pkgs;
            ${if builtins ? currentSystem then "repoOverrides" else null} = {
              slaier = import /home/nixos/repos/nur-packages { inherit pkgs; };
            };
          };

          nurOverlay = final: prev: {
            nur = nurWithPkgs prev;
          };

          nurModules = nurWithPkgs nixpkgs.legacyPackages.${system};
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            impermanence.nixosModules.impermanence
            nurModules.repos.slaier.modules.clash

            {
              nixpkgs.overlays = [
                self.overlay
                nurOverlay
              ];
              nixpkgs.config = {
                allowUnfree = true;
                permittedInsecurePackages = [
                  "qtwebkit-5.212.0-alpha4"
                ];
              };
              nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
              nix.registry.nixpkgs.flake = nixpkgs;
            }

            host.nixosModule

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                inherit (host) users;
                useGlobalPkgs = true;
                useUserPackages = true;
              };
            }
          ];
        });
      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
          };
        };
      } // mapAttrs
        (name: value: {
          nixpkgs.system = value.config.nixpkgs.system;
          imports = value._module.args.modules;
          deployment.allowLocalDeployment = true;
        })
        self.nixosConfigurations;
    };

  nixConfig = {
    extra-substituters = [
      "https://slaier.cachix.org"
    ];
    extra-trusted-public-keys = [
      "slaier.cachix.org-1:NyXPOqlxuGWgyn0ApNHMopkbix3QjMUAcR+JOjjxLtU="
    ];
  };
}
