{ super, lib, inputs, ... }:
with lib;
recursiveUpdate
  (mapAttrs
    (name: value: {
      nixpkgs.system = value.config.nixpkgs.system;
      imports = value._module.args.modules;
      deployment.allowLocalDeployment = true;
      deployment.targetHost = optionalString (name != "local") (name + ".local");
    })
    super.nixosConfigurations)
{
  meta = {
    nixpkgs = import inputs.nixpkgs {
      system = lib.system.x86_64-linux;
    };
  };
}
