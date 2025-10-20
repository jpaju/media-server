{ config, ... }:
let
  repository = "sftp:media-server@jp-nas1.int.jpaju.fi:/Backupit/media-server";
  passwordFile = config.sops.secrets.restic_repository_password.path;

  plex = {
    include = [ "/srv/plex" ];
    exclude = [
      "/srv/plex/Plex Media Server/Cache"
      "/srv/plex/Plex Media Server/Crash Reports"
      "/srv/plex/Plex Media Server/Logs"
    ];
  };
  music-assistant = {
    include = [ "/srv/music-assistant" ];
    exclude = [ "/srv/music-assistant/.cache" ];
  };
in
{
  services.restic.backups.media = {
    inherit repository passwordFile;

    initialize = true;
    createWrapper = true;
    runCheck = true;

    extraBackupArgs = [ "--verbose" ];

    timerConfig = {
      OnCalendar = "22:00";
      Persistent = true;
    };

    pruneOpts = [
      "--keep-daily 30"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 5"
    ];

    paths = plex.include ++ music-assistant.include;
    exclude = plex.exclude ++ music-assistant.exclude;
  };
}
