{ dotfiles, ... }:
{
  imports = [
    dotfiles.systemModules.nix-settings
    ./configuration.nix
    ./hardware-configuration.nix
    ./ssh-server.nix
  ];
}
