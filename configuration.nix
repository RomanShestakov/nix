{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./custom-configuration.nix
 ];

swapDevices = [ { device = "/swapfile"; size = 1024; } ];

boot.kernelParams = [ "cma=32M" ];
boot.cleanTmpDir = true;
services.openssh.enable = true;
services.openssh.permitRootLogin = "yes";

# Creates a "nix" user with password-less sudo access
users = {
  extraGroups = [ { name = "nix"; } ];
  extraUsers  = [
    # Try to avoid ask password
    { name = "root"; password = "nix"; }
    {
      description     = "Nix User";
      name            = "nix";
      group           = "nix";
      extraGroups     = [ "users" "wheel" ];
      password        = "nix";
      home            = "/home/nix";
      createHome      = true;
      useDefaultShell = true;
    }
  ];
};

fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };
}
