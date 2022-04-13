{ backend, frontend, ... }: {
  systemd.services.backend = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = { ExecStart = "${backend}/bin/backend"; };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."localhost" = {
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:8000";
      locations."/static/".alias = "${frontend}/static/";
    };
  };
}
