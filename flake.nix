{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.utils.follows = "flake-utils";

    nur.url = "github:nix-community/NUR";

    impermanence.url = "github:nix-community/impermanence";

    darkmatter-grub-theme.url = "gitlab:VandalByte/darkmatter-grub-theme";
    darkmatter-grub-theme.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";

    haumea = {
      url = "github:nix-community/haumea";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, haumea, ... } @inputs:
    let
      src = haumea.lib.load {
        src = ./src;
        loader = haumea.lib.loaders.verbatim;
      };
      hosts = haumea.lib.load {
        src = ./hosts;
        loader = haumea.lib.loaders.verbatim;
      };
    in
    haumea.lib.load {
      src = ./outputs;
      inputs = {
        inherit src hosts inputs;
        lib = nixpkgs.lib // flake-utils.lib;
      };
    };
}
