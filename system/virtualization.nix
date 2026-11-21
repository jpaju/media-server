{ ... }:
{
  virtualisation.oci-containers.backend = "podman";

  virtualisation.podman = {
    enable = true;

    dockerCompat = true;
    dockerSocket.enable = true;

    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [
        "--all"
        "--filter"
        "until=168h" # 7 days
      ];
    };
  };
}
