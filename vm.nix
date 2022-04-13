{ pkgs, ... }: {
  virtualisation = {
    cores = 2;
    memorySize = 2048;
    diskSize = 20 * 1024;
  };

  nixos-shell.mounts = {
    mountHome = false;
    mountNixProfile = false;
    cache = "none";
  };

  virtualisation.forwardPorts = [{
    from = "host";
    host.port = 8081;
    guest.port = 443;
  }];

  services.nginx = {
    virtualHosts."localhost" = {
      sslCertificate =
        "${pkgs.path}/nixos/tests/common/acme/server/acme.test.cert.pem";
      sslCertificateKey =
        "${pkgs.path}/nixos/tests/common/acme/server/acme.test.key.pem";
    };
  };
}
