# NixOS media server

This repository contains [NixOS](https://nixos.org/) system configuration for a media server that hosts [Plex](https://www.plex.tv/) and [Music Assistant](https://music-assistant.io/).

## Architecture

This system uses NixOS for system-level configuration and services:

- **NixOS** manages the host system, networking, nginx reverse proxy, and media services
- **Plex** runs as a native NixOS systemd service
- **Music Assistant** runs as an OCI container managed by systemd
- **Nginx** provides SSL termination and reverse proxy to services
- **Persistent data** is stored in `/srv/plex` and `/srv/music-assistant` directories
- **Restic** handles automated backups of persistent data to remote NAS

## External configuration

Configuration required outside of this repository on routers, network devices, and host systems.

### DNS configuration

Services are accessible only from local networks (192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12).

Configure your DNS to point service domains to this NixOS host IP.
The specific domain names can be found in the `media/nginx.nix` file.

### NAS SMB mount

Plex is configured to access media files from a NAS via SMB mount at `/mnt/media`.
SMB credentials are managed through sops-nix secrets.

### Synology NAS SFTP setup

Restic requires non-interactive SFTP login for automated backups. Therefore, public key authentication must be configured.

- Generate a keypair for the **root user** on the media-server machine
- Temporarily add the backup user to Synology's administrators group to enable SSH access
- Copy the SSH public key to Synology using: `ssh-copy-id <user>@<synology-host>`
- Remove the backup user from Synology's administrators group after setup

## NixOS configuration

### Applying system changes

When you make changes to the NixOS configuration files, you need to rebuild the system to apply changes:

```bash
nixos-rebuild switch
```

### Rolling back changes

If a new configuration causes issues, you can roll back to a previous generation:

```bash
# Roll back to the previous generation
nixos-rebuild switch --rollback

# Or list available generations
nixos-rebuild list-generations

# And switch to a specific generation (replace N with the generation number)
sudo /nix/var/nix/profiles/system-N-link/bin/switch-to-configuration switch
```

## Media services

### Services startup

Media services are configured to start automatically with systemd when the server boots up.
If you need to manually restart the services, you can use:

```bash
systemctl restart plex
systemctl restart podman-music-assistant
```

### Data persistence

Service data is stored in the `/srv/` folder on the host system:

- `/srv/plex/` - Plex Media Server data
- `/srv/music-assistant/` - Music Assistant data

### Backups

We use Restic for backups, which automatically backs up files from the `/srv` folder to a remote NAS daily.

### Viewing logs

To view logs from the services:

```bash
journalctl --unit plex --follow
journalctl --unit podman-music-assistant --follow
```

## Secrets management

Secrets are managed with [sops-nix](https://github.com/Mic92/sops-nix) and encrypted with age keys, allowing them to be safely committed to git.

### Prerequisites

Ensure you have the age key configured at `/etc/sops/age/keys.txt`.

### Editing secrets

```bash
sops system/secrets/secrets.yaml
```

This opens the secrets file in your `$EDITOR`. Make your changes, then save and quit. The file will be automatically encrypted.

## Dependency updates

TODO

## Development tools

### VS Code Remote SSH

To connect to this NixOS host with VS Code Remote SSH, you must add the following setting to your VS Code `settings.json`:

```json
"remote.SSH.useLocalServer": false
```

This is required because the default shell is fish, and there's an [open issue](https://github.com/microsoft/vscode-remote-release/issues/2509) with VS Code Remote SSH and fish shell.
