{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./custom-configuration.nix
 ];

  # # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.device = "/dev/sda";

  # # remove the fsck that runs at startup. It will always fail to run, stopping
  # # your boot until you press *.
  # boot.initrd.checkJournalingFS = false;

  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelParams = [ "cma=32M" ];
  boot.cleanTmpDir = true;
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  # Creates a "nix" user with password-less sudo access
  users = {
    extraGroups = [ { name = "nix"; } ];
    extraUsers  = [
      # Try to avoid ask password
      #{ name = "root"; password = "nix"; }
      {
        description     = "Nix User";
        name            = "nix";
        group           = "nix";
        extraGroups     = [ "users" "wheel" ];
        password        = "nix";
        home            = "/home/nix";
        createHome      = true;
        useDefaultShell = true;
        isNormalUser    = true;
      }
    ];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  swapDevices = [ { device = "/swapfile"; size = 1024; } ];

# fileSystems = {
#     "/boot" = {
#       device = "/dev/disk/by-label/NIXOS_BOOT";
#       fsType = "vfat";
#     };
#     "/" = {
#       device = "/dev/disk/by-label/NIXOS_SD";
#       fsType = "ext4";
#     };
#   };
}
