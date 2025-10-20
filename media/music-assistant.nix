{ ... }:
let
  dataFolder = "/srv/music-assistant";
  musicAssistantVersion = "2.6.0";
in
{
  virtualisation.oci-containers.containers.music-assistant = {
    image = "ghcr.io/music-assistant/server:${musicAssistantVersion}";
    autoStart = true;
    extraOptions = [ "--network=host" ];

    volumes = [
      "${dataFolder}:/data"
    ];

    environment = {
      TZ = "Europe/Helsinki";
      LOG_LEVEL = "info";
    };
  };

  systemd.tmpfiles.settings."10-music-assistant".${dataFolder}.d = {
    user = "root";
    group = "wheel";
    mode = "0774";
  };
}
