{
  pkgs,
  config,
  username,
  sops-nix,
  ...
}:
let
  ageKeyFile = "/etc/sops/age/keys.txt";
in
{
  imports = [ sops-nix.nixosModules.sops ];

  environment.systemPackages = with pkgs; [
    git
    sops
  ];

  environment.variables.SOPS_AGE_KEY_FILE = ageKeyFile;

  sops = {
    age.keyFile = ageKeyFile;
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";

    secrets.anthropic_api_key.owner = username;
    secrets.openai_api_key.owner = username;

    secrets.cloudflare_api_token = { };
    secrets.restic_repository_password = { };
    secrets.smb_username = { };
    secrets.smb_password = { };
    templates.smb-credentials.content = ''
      username=${config.sops.placeholder.smb_username}
      password=${config.sops.placeholder.smb_password}
    '';
  };
}
