{ ... }:
let
  versions = builtins.fromJSON (builtins.readFile ./versions.json);
  dataFolder = "/srv/music-assistant";
in
{
  virtualisation.oci-containers.containers.music-assistant = {
    image = "ghcr.io/music-assistant/server:${versions.musicAssistant}";
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
