{ systemStateVersion, ... }:
{
  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  virtualisation.vmware.guest.enable = true;

  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fi";

  # Enables the use of dynamically linked binaries not built for nix, for example VS Code server
  programs.nix-ld.enable = true;

  security.sudo.wheelNeedsPassword = false;

  networking.hostName = "media-server";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = systemStateVersion;
}
