{ ... }: {
  virtualisation.oci-containers.containers.qinglong = {
    image = "docker.io/whyour/qinglong:latest";
    volumes = [
      "/etc/qinglong:/ql/data"
    ];
    ports = [ "5700:5700" ];
  };
}
