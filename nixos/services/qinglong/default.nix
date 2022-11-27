{ lib, ... }: {
  virtualisation.oci-containers.containers.qinglong = {
    image = "docker.io/whyour/qinglong:latest";
    volumes = [
      "/var/lib/qinglong:/ql/data"
    ];
    ports = [ "5700:5700" ];
  };
  system.activationScripts.qinglong = lib.stringAfter [ "var" ] ''
    mkdir -p /var/lib/qinglong
  '';
}
