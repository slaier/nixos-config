{ pkgs, ... }: {
  virtualisation.oci-containers.containers.openfortivpn = {
    image = "ghcr.io/slaier/openfortivpn:latest";
    imageFile = pkgs.dockerTools.pullImage {
      imageName = "ghcr.io/slaier/openfortivpn";
      imageDigest = "sha256:12f9347274251cafa080a93d98e8645382b0fee36e2d55f97dd012e877e14dac";
      sha256 = "sha256-m+XsPBinsOI864hwZWqW0uBvVkgjZIhlPpyMXYQqP4U=";
      os = "linux";
      arch = "arm64";
    };
    volumes = [
      "/etc/openfortivpn/config:/etc/openfortivpn/config"
    ];
    extraOptions = [
      "--device=/dev/ppp"
      "--cap-add=NET_ADMIN"
      "--init"
    ];
    ports = [ "1080:1080" ];
    autoStart = false;
  };
}
