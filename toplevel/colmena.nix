{ super, lib, inputs, ... }:
with lib;
recursiveUpdate
  (mapAttrs
    (name: value: {
      nixpkgs.system = value.config.nixpkgs.system;
      imports = value._module.args.modules;
      deployment.allowLocalDeployment = true;
      deployment.targetHost = mkIf (name == "local") null;
    })
    super.nixosConfigurations)
{
  meta = {
    nixpkgs = import inputs.nixpkgs {
      system = lib.system.x86_64-linux;
    };
  };
}
