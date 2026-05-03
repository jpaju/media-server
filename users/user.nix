{ pkgs, username, ... }:
{
  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "podman"
    ];
    shell = pkgs.fish;
  };

}
