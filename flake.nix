{
  description = "NixOS configuration for media server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:jpaju/dotfiles/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";
      username = "jaakko";
      userhome = "/home/${username}";

      # DO NOT CHANGE THESE
      homeStateVersion = "25.05";
      systemStateVersion = "24.11";

      specialArgs = {
        inherit
          inputs
          system
          username
          userhome
          homeStateVersion
          systemStateVersion
          ;
      };
    in
    {
      nixosConfigurations.media-server = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;

        modules = [
          inputs.dotfiles.exports.options
          ./profile.nix
          ./system
          ./users
          ./media
        ];
      };
    };
}
