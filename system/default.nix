{ inputs, ... }:
{
  imports = [
    inputs.dotfiles.exports.nix-settings
    inputs.dotfiles.inputs.determinate.nixosModules.default
    ./configuration.nix
    ./garbage-collection.nix
    ./hardware-configuration.nix
    ./secrets
    ./ssh-server.nix
    ./virtualization.nix
  ];
}
