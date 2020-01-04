{ config, pkgs, lib, ... }:
{
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # remove the fsck that runs at startup. It will always fail to run, stopping
  # your boot until you press *.
  boot.initrd.checkJournalingFS = false;

  # Services to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable DBus
  services.dbus.enable    = true;

  # Replace ntpd by timesyncd
  services.timesyncd.enable = true;

  # Packages for Vagrant
  environment.systemPackages = with pkgs; [
    nettools
    netcat
    rsync
  ];

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
        isNormalUser    = true;
        openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPprfOsihngVXGh2rzarrdGhiBny43R+cjTY3H9SQT9cKyEgG5X1VRMKD3zPkFcwIw7VKNhj+V75gbjGEWFqIDbDJe0oaeXuVrmVYeaSxQOMkN78qqSShhwANWFLxRAAFVTm4fZknBDxwwf22LNib8S482j+sp4fV45fC7d8XGR3iULSqE92yQxv3ANsEfOJOvsUrNnOcn+bB1EQcMAXqlVo4uM9q8fnco4fwTFxbJWqJwNW9Rcjs/h8xm9lLE096As2nKZOTH4iYusND5whKZoHkNIui4bFD0G/WrqwqzVOdfm2w/vK0K4OZd+H+UdNuwtRmPMujhGmLRDntotIZGj1L0O9g1j8BF6BEOCaX2Sp/YiletsYVkPk2QtAI4SRDbcfQ5Ba44K/XR1CYVPjiQjftiyXTwO+4Az/IAMfQFr6GI5KO3XZQg9JW6W0PCB0HtGkiXITiWrlzEvSucU+jjJFnaBOL82kJLY7SJorFLaFvnTk1qY5VqLeaDfWPiJjimnwzC6AJAkrBFmLovEpaNwN3aRS4mNwpCgID6fOwq6rMqb74VQG22ZOtpnBrH1TAsY1eKmPpFH3rwIbh/+ZuHvXk4nvxMrvwdex4QFU9E6xCdCA95EGRCZNXA9alSroBXt7rZ7yBqngVaecwQcpwVcMZ7CPiBFO+gb6QdbPMzow== nix@local" ];
      }
    ];
  };
  
  # File systems configuration for using the installer's partition layout
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
    
  swapDevices = [ { device = "/swapfile"; size = 1024; } ];
}
