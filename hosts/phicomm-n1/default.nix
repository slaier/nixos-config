{ ... }: {
  imports = [
    ../../nixos/core
    ../../nixos/users
  ];
  networking.hostName = "n1";
}
