{ lib, inputs, ... }:
(lib.eachDefaultSystem (system: {
  default = (import inputs.nixpkgs { inherit system; }).nixpkgs-fmt;
})).default
