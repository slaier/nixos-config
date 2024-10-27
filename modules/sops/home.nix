{ lib, config, nixosConfig, ... }:
{
  sops = {
    defaultSopsFile = nixosConfig.sops.defaultSopsFile;
    age.keyFile = nixosConfig.sops.age.keyFile;
  };
  systemd.user.services.sops-nix.Environment = lib.mkForce config.sops.environment;
  home.sessionVariables.SOPS_AGE_KEY_FILE = config.sops.age.keyFile;
  sops.secrets.ssh-config = {
    format = "binary";
    sopsFile = ../../secrets/ssh-config;
    path = "${config.home.homeDirectory}/.ssh/config";
  };
}
