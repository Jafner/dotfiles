{pkgs, ...}: {
  environment.systemPackages = with pkgs; [cifs-utils];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e29ec340-6231-4afe-91a8-aaa2da613282";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-partuuid/ff24dcbc-39e9-4bbe-b013-50d755c9d13d";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/f023ae02-7742-4e13-a8ea-c1ea634436fa";
    fsType = "btrfs";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/73e8e737-1c5c-4ead-80c6-e616be538145";}];

  fileSystems."/home/joey/stash" = {
    enable = true;
    mountPoint = "/home/joey/stash";
    device = "//192.168.1.12/AV";
    fsType = "cifs";
    options = [
      "vers=3"
      "credentials=/home/joey/.smbcred"
      "uid=1000,forceuid"
      "gid=1000,forcegid"
    ];
  };
  fileSystems."/home/joey/torrenting" = {
    enable = true;
    mountPoint = "/home/joey/torrenting";
    device = "//192.168.1.12/Torrenting";
    fsType = "cifs";
    options = [
      "vers=3"
      "credentials=/home/joey/.smbcred"
      "uid=1000,forceuid"
      "gid=1000,forcegid"
    ];
  };
  fileSystems."/home/joey/recordings" = {
    enable = true;
    mountPoint = "/home/joey/recordings";
    device = "//192.168.1.12/Recordings";
    fsType = "cifs";
    options = [
      "vers=3"
      "credentials=/home/joey/.smbcred"
      "uid=1000,forceuid"
      "gid=1000,forcegid"
    ];
  };
}
