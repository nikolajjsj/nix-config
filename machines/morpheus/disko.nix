{
  disko.devices = {
    disk = {
      boot = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S5GXNU0WC27180T";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "nofail" "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
      boot_fallback = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_1000GB_24127V4A2P01";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot-fallback";
                mountOptions = [ "nofail" "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
      rust_1 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST12000NM001G-2MV103_WL20ND10";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rust";
              };
            };
          };
        };
      };
      rust_2 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST12000NM001G-2MV103_ZL24PT7Z";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rust";
              };
            };
          };
        };
      };
      rust_3 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST12000NM0558_ZHZ1SH9J";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rust";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        mode = "mirror";
        options.ashift = "12";
        rootFsOptions = {
          mountpoint = "none";
          compression = "zstd";
          acltype = "posixacl";
          xattr = "sa";
          atime = "off";
          "com.sun:auto-snapshot" = "false";
        };
        mountpoint = "/";

        datasets = {
          "enc" = {
            type = "zfs_fs";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "prompt";
            };
          };

          "enc/local/root" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/";
            postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot/enc/local/root@blank$' || zfs snapshot zroot/enc/local/root@blank";
          };
          "enc/local/nix" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
          };
          "enc/safe/home" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/home";
          };
          "enc/safe/persist" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/persist";
          };
        };
      };
      rust = {
        type = "zpool";
        mode = "raidz";
        rootFsOptions = {
          mountpoint = "none";
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };

        datasets = {
          enc = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "file:///tmp/rust.key";
            };
            postCreateHook = ''
              zfs set keylocation="file:///persist/keys/rust.key" "rust/enc";
            '';
          };
          "enc/media" = {
            type = "zfs_fs";
            mountpoint = "/mnt/media";
            options.mountpoint = "legacy";
          };
          "enc/syncthing" = {
            type = "zfs_fs";
            mountpoint = "/mnt/syncthing";
            options.mountpoint = "legacy";
          };
        };
      };
    };
  };
}
