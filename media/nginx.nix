{ config, lib, ... }:
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx = {
    enable = true;

    virtualHosts =
      let
        internalDomain = "int.jpaju.fi";

        proxyTo =
          {
            backendUrl,
            port ? null,
          }:
          {
            locations."/" = {
              proxyPass = backendUrl;
              proxyWebsockets = true;
              recommendedProxySettings = true;
            };

            listen = lib.optionals (port != null) [
              {
                addr = "0.0.0.0";
                port = port;
                ssl = true;
              }
            ];

            forceSSL = true;
            enableACME = true;
            acmeRoot = null;

            extraConfig = ''
              allow 192.168.0.0/16;
              allow 10.0.0.0/8;
              allow 172.16.0.0/12;
              deny all;
            '';
          };
      in
      {
        "music-assistant.${internalDomain}" = proxyTo { backendUrl = "http://localhost:8095"; };
        "plex.${internalDomain}" = proxyTo { backendUrl = "http://localhost:32400"; };
      };
  };

  security.acme = {
    acceptTerms = true;

    defaults = {
      email = "jpaju.admin+acme@icloud.com";
      dnsProvider = "cloudflare";
      credentialFiles.CF_DNS_API_TOKEN_FILE = config.sops.secrets.cloudflare_api_token.path;
    };
  };
}
