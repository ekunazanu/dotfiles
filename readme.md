The following are the steps to create an encrypted-BTRFS Arch setup on an SSD. This is a personal reference as quick checklist from the [Arch Wiki](https://wiki.archlinux.org/title/Installation_guide) to set it up, in case I break or brick my laptop again. PS. If someone else is using the dotfiles, **DO NOT clone the .gitconfig** — you'll probably want to edit it before you go signing off commits on my behalf :)

## Base Installation

1. Get an [Arch installation medium](https://wiki.archlinux.org/title/USB_flash_installation_medium). Flash the image on the drive `# cat path/to/archlinux-version-x86_64.iso > /dev/drive` — or `# pv path/to/archlinux-version-x86_64.iso -Yo /dev/drive` for progress bars.

2. Boot in x64 UEFI mode and connect to the internet using `# iwctl station <wlan> connect <network>`. Check connection using `# ping archlinux.org` and verify clock is synchronized `# timedatectl`.

3. Partition the disk `# fdisk /dev/disk`. Create a GPT partition table. Create partitions as below:

```
+-----------------------+----------------------+-------------------------+
| Boot partition — 1    | Swap — 2             | Encrypted partition — 3 |
|                       |                      |                         |
| /dev/nvme0n1p1        | /dev/nvme0n1p2       | /dev/nvme0n1p3          |
|                       |                      |                         |
| EFI — 001             | Linux Swap — 019     | Linux — 020             |
|                       |                      |                         |
| 1GiB                  | 8GiB (or 2xRAM)      | Remaining               |
|                       |                      |                         |
| /boot                 | [SWAP]               | /                       |
+-----------------------+----------------------+-------------------------+
```

4. Create a FAT32 filesystem on boot patitition `# mkfs.fat -n "boot" -F32 /dev/nvme0n1p1`.

5. Create a dm-crypt filesystem on main partition `# cryptsetup -v luksFormat /dev/nvme0n1p3` and open the block device `# cryptsetup open /dev/nvme0n1p3 root`.

6. Create a BTRFS filesystem on the mapper device `# mkfs.btrfs -L "root" --csum xxhash /dev/mapper/root`. [Possible checksum algorithms](https://man.archlinux.org/man/btrfs.5#CHECKSUM_ALGORITHMS).

7. Mount the partition `# mount /dev/mapper/root /mnt` and create BTRFS subvolumes `# btrfs subvolume create /mnt/{@,@home,@log,@var,@snapshots}`.

8. Unmount the partition and mount the subvolumes `# mount --mkdir -o rw,noatime,compress-force=zstd:3,nodiscard,subvol=@ /dev/mapper/root /mnt/`. Similarly mount the subvolumes @home, @var, @log, and @snapshots at /mnt/home, /mnt/var, /mnt/var/log, and /mnt/snapshots respectively. Mount boot partition `# mount --mkdir /dev/nvme0n1p1 /mnt/boot`.

9. Install packages on new mount point using `# pacstrap -K /mnt base base-devel arch-install-scripts intel-ucode amd-ucode linux linux-lts linux-firmware man-db man-pages smartmontools dosfstools btrfs-progs snapper rsync openssh iwd iptables-nft wireguard-tools mesa libinput reflector git git-lfs playerctl brightnessctl pipewire pipewire-pulse wireplumber zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting xorg-server-xwayland libnotify i3blocks sway swaybg swayidle swaylock mako wlsunset jq grim slurp wf-recorder wl-clipboard cliphist kanshi xdg-desktop-portal-wlr noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-jetbrains-mono inter-font ttf-nerd-fonts-symbols ttf-font-awesome neovim foot imv mpv yt-dlp aria2 ncspot yazi bat gitui minisign tesseract tesseract-data-eng zbar qrencode imagemagick firefox obsidian`.

Install `libva-intel-driver intel-media-driver` if using an [Intel GPU](https://wiki.archlinux.org/title/Hardware_video_acceleration#Intel) for VA-API. VA-API for AMD and NVIDIA are supported via the default mesa driver. Install one of `vulkan-intel vulkan-radeon vulkan-nouveau` [depending on GPU](https://wiki.archlinux.org/title/Vulkan) if Vulkan is required. Verify VA-API later after install using [vainfo](https://wiki.archlinux.org/title/Hardware_video_acceleration#Verification) and `$ mpv --hwdec=auto`.

10. Edit /mnt/etc/crypttab to enable encrypted swap:

```
/mnt/etc/crypttab
-----------------
swap    /dev/disk/by-id/id    /dev/urandom    swap,cipher=aes-xts-plain64,size=512,sector-size=4096
```

Where `id` is the (persistent) ID of /dev/nvme0n1p2 `# find -L /dev/disk -samefile /dev/nvme0n1p2`. Use any of the IDs from `/dev/by-id`. It is important to **use ID instead of UUID** since the UUID changes every boot.

11. Generate the filesystem table for /mnt `# genfstab -U /mnt >> /mnt/etc/fstab`. Add entry for swap partition and verify mount options for other partitions and subvolumes.

```
/mnt/etc/fstab
--------------
UUID=uuid3        /            btrfs    rw,noatime,compress-force=zstd:3,nodiscard,subvol=@          0 0
UUID=uuid3        /home        btrfs    rw,noatime,compress-force=zstd:3,nodiscard,subvol=@home      0 0
UUID=uuid3        /var         btrfs    rw,noatime,compress-force=zstd:3,nodiscard,subvol=@var       0 0
UUID=uuid3        /var/log     btrfs    rw,noatime,compress-force=zstd:3,nodiscard,subvol=@log       0 0
UUID=uuid3        /snapshots   btrfs    rw,noatime,compress-force=zstd:3,nodiscard,subvol=@snapshots 0 0
UUID=uuid1        /boot        vfat     rw,relatime,fmask=0137,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro 0 2
/dev/mapper/swap  none         swap     defaults                                                     0 0
```

Where `uuid1` is the UUID for /dev/nvme0n1p1, and `uuid3` is the UUID for /dev/mapper/root (not /dev/nvme0n1p3).

12. Chroot into /mnt `# arch-chroot /mnt`.

13. Set the timezone `# ln -sf /usr/share/zoneinfo/Region/City /etc/localtime` and clock `# hwclock --systohc`.

14. Uncomment `en_US.UTF-8 UTF-8` in /etc/locale.gen and generate locale `# locale-gen`.

15. Set `LANG=en_US.UTF-8` in /etc/locale.conf and keyboard layout `KEYMAP=us` in /etc/vconsole.conf.

16. Set hostname `lazyleopard` in /etc/hostname.

17. Add systemd encrypt [hooks](https://wiki.archlinux.org/title/Mkinitcpio#Common_hooks) for initramfs `HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck)` in /etc/mkinitcpio.conf. Recreate initramfs `# mkinitcpio -P`.

18. Verify if live installation medium was booted in UEFI mode `# ls /sys/firmware/efi/efivars`. If the directory exists, the system is booted into UEFI mode. If not, reboot in x64 UEFI mode and re-mount partitions and re-chroot into the system.

19. Install systemd-boot `# bootctl install`. Add the boot loader and entry configs.

```
/boot/loader/loader.conf
------------------------
default  arch.conf
timeout  0
editor no
```

```
/boot/loader/entries/arch.conf
------------------------------
Linux /vmlinuz-linux
initrd /amd-ucode.img (or initrd /intel-ucode.img)
initrd /initramfs-linux.img
options rd.luks.name=UUID=root root=/dev/mapper/root rd.luks.options=discard rootflags=subvol=@
```

Where `UUID` is the UUID for /dev/nvme0n1p3. Add similar configs for arch-lts.conf, arch-fallback.conf, and arch-lts-fallback.conf.

```
/boot/loader/entries/arch-lts.conf
----------------------------------
title Arch Linux LTS
Linux /vmlinuz-linux-lts
initrd /amd-ucode.img
initrd /initramfs-linux-lts.img
options rd.luks.name=UUID=root root=/dev/mapper/root rd.luks.options=discard rootflags=subvol=@
```

```
/boot/loader/entries/arch-fallback.conf
---------------------------------------
title Arch Linux Fallback
Linux /vmlinuz-linux
initrd /amd-ucode.img
initrd /initramfs-linux-fallback.img
options rd.luks.name=UUID=root root=/dev/mapper/root rd.luks.options=discard rootflags=subvol=@
```

```
/boot/loader/entries/arch-lts-fallback.conf
-------------------------------------------
title Arch Linux LTS Fallback
Linux /vmlinuz-linux-lts
initrd /amd-ucode.img
initrd /initramfs-linux-lts-fallback.img
options rd.luks.name=UUID=root root=/dev/mapper/root rd.luks.options=discard rootflags=subvol=@
```

20. Add non-root user with sudo privileges `# useradd -m -G wheel -s /bin/zsh ekunazanu`. Add wheel to sudoers `# EDITOR=nvim visudo` and uncomment `%wheel ALL=(ALL:ALL) NOPASSWD: ALL`.

21. Set passwords `# passwd` and `# passwd ekunazanu`.

22. Reboot into the new system `# systemctl reboot`.

## System

1. Uncomment `VerbosePkgLists`, `CheckSpace`, `Color` and `ParallelDownloads = 6` in /etc/pacman.conf.

2. Enable reflector `# systemctl enable reflector.timer` and add `--save /etc/pacman.d/mirrorlist --connection-timeout 5 --download-timeout 5 --protocol https --completion-percent 100.0 --country de,fr,ch,nl,no,fi,be,at --age 2 --score 20 --sort rate` to /etc/xdg/reflector/reflector.conf.

3. Enable periodic trim `# systemctl enable fstrim.timer`.

4. Enable NTP by enabling systemd-timesyncd service `# systemctl enable systemd-timesyncd.service`. Add NTP servers in /etc/systemd/timesyncd.conf.

```
/etc/systemd/timesyncd.conf
---------------------------
[Time]
NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
FallbackNTP=0.pool.ntp.org 1.pool.ntp.org
```

5. Add a DNS resolver by enabling systemd-resolved `# systemctl enable systemd-resolved.service`. Create a symbolic link from systemd-resolved to /etc/resolv.conf `# ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf`. The symlink can be detected by systemd-networkd, and automatically set up DNS resolution for applications that use /etc/resolv.conf. For custom DNS servers, edit /etc/system/resolved.conf (not necessary unless specific DNS servers need to be used).

```
/etc/systemd/resolved.conf
--------------------------
[Resolve]
DNS = 1.1.1.1
FallbackDNS = 1.1.1.1 9.9.9.9 8.8.8.8 2606:4700:4700::1111 2620:fe::9 2001:4860:4860::8888
```

6. Enable DHCP via systemd-networkd. Enable systemd-networkd `# systemctl enable systemd-networkd.service` and systemd-networkd-wait-online `# systemctl enable systemd-networkd-wait-online.service`. Add network configuration files in /etc/systemd/network/. Note: The configuration priority is based on file names in lexicographical order.

```
/etc/systemd/network/25-simple-wireless-dhcp.network
----------------------------------------------------
[Match]
Name=wlan0

[Network]
DHCP=yes
```

Where `wlan0` is the (wireless) interface name from `$ ip a`. Connect to a wireless network `# iwctl station <interface> connect <ssid>`. To connect to known wireless networks automatically on boot, enable iwd `# systemctl enable iwd.service`.

7. For VPN using WireGuard, create virtual device wg0 to tunnel (all) packets to VPN server. The example below uses assumptions about addresses and ports. Use configurations from the VPN provider.

```
 packets ----------> wg0 ----------------------> VPN server

 0.0.0.0/0           10.2.0.2/32                 217.1.1.1
 ::0                 fdc9:281f:04d7:9ee9::1/64   -
 -                   UDP/51819                   UDP/51820
 DNS 8.8.8.8 etc     DNS 10.2.0.1                -
```

The above routes all packets (0.0.0.0/0, ::0) to wg0, which tunnels it to endpoint VPN server 217.1.1.1 (IPv6 too can be added if offered by VPN provider). VPN server is listening on port 58120. The wg0 virtual device can also receive data from VPN server on port 51819 if required. The virtual device/tunnel can be created using systemd-networkd using a configuration file.

```
/etc/systemd/network/99-wg0.netdev
----------------------------------
[NetDev]
Name = wg0
Kind = wireguard
Description = WireGuard tunnel wg0

[WireGuard]
ListenPort = 51819
PrivateKey = private_key
FirewallMark = 0x8888

[WireGuardPeer]
PublicKey = public_key
PresharedKey = preshared_key
AllowedIPs = 0.0.0.0/0
AllowedIPs = ::0
Endpoint = 217.1.1.1:51820
```

Route all packets via wirguard tunnel wg0.

```
/etc/systemd/network/50-wg0.network
-----------------------------------
[Match]
Name = wg0

[Network]
Address = 10.2.0.2/32
DNS = 10.2.0.1
DNSDefaultRoute = true
Domains = ~.

[RoutingPolicyRule]
FirewallMark = 0x8888
InvertRule = true
Table = 1000
Priority = 10

# exempt endpoint so wireguard can still connect
[RoutingPolicyRule]
To = 217.1.1.1/32
Priority = 5

[Route]
Destination = 0.0.0.0/0
Table = 1000

[Route]
Destination = ::0
Table = 1000
```

Prevent other users from reading private keys `# chown root:systemd-network /etc/systemd/network/99-wg0.netdev` and `# chmod 0640 /etc/systemd/network/99-wg0.netdev`. Check connection `# wg`.

8. Enable firewall `# systemctl enable ntables.service`. Set up a simple firewall in /etc/nftables.conf.

```
/etc/nftables.conf
------------------
#!/usr/bin/nft -f

flush ruleset

define public_interface = {"eno1", "wlan0"}
define wireguard_interface = "wg0"
define wireguard_endpoint = 217.1.1.1
define wireguard_port = 51819

table inet filter {
    chain input {
        type filter hook input priority 0
        policy drop

        # drop invalid connections
        ct state invalid drop
        # accept established connections
        ct state {established, related} accept
        # accept loopback
        iifname "lo" accept
        # accept icmp/icmpv6 packets
        meta l4proto {icmp, ipv6-icmp} accept
        # accept DHCPv6 packets received at a link-local address
        ip6 daddr fe80::/64 udp dport dhcpv6-client accept
        # accept SSH packets
        tcp dport ssh accept
        # accept wireguard packets from public interface
        # iifname $public_interface udp dport $wireguard_port ip saddr $wireguard_endpoint accept
        # accept http packets from wireguard interface
        # iifname $wireguard_interface tcp dport http accept
        # reject when over rate limit
        pkttype host limit rate 5/second counter reject with icmpx type admin-prohibited
        # count rejected packets
        counter
        # drop new connections over rate limit
        # ct state new limit rate over 1/second burst 10 packets drop
        # reject with "port unreachable"
        # reject
    }

    chain forward {
        type filter hook forward priority 0
        policy drop

        # reject all forwards with "host unreachable"
        # reject with icmpx type host-unreachable
    }
}
```

8. Create systemd units for creating weekly BTRFS snapshots in /etc/systemd/system/:

```
/etc/systemd/system/btrfs-snapshot@.timer
-----------------------------------------
[Unit]
Description = Timer for creating BTRFS snapshots.
Documentation = man:btrfs-subvolume(8)

[Timer]
OnCalendar = weekly
Acccuracy = 2d
Persistent = true

[Install]
WantedBy = timers.target
```

```
/etc/systemd/system/btrfs-snapshot@.service
-------------------------------------------
[Unit]
Description = Create a readonly BTRFS snapshot.
Documentation = man:btrfs-subvolume(8)
Conflicts = btrfs-scrub.service
After = local-fs.target

[Install]
WantedBy = local-fs.target

[Service]
Type = simple
ExecStart = /bin/sh -ec "/bin/btrfs subvolume snapshot -r %f /snapshots/$(date -Iseconds)-%i"
CPUSchedulingPolicy = idle
IOSchedulingClass = idle
StandardOutput = journal
StandardError = journal
SyslogIdentifier = BTRFS-snapshot
```

Enable the timers `# systemctl enable btrfs-snapshot@-.timer` `# systemctl enable btrfs-snapshot@home.timer` `# systemctl enable btrfs-snapshot@var-log.timer`. Snapshots for @var are not strictly necessary.

Note: To restore a subvolume snapshot, delete the existing subvolume `# btrfs subvolume delete /@home` and restore by creating a (snapshot) subvolume from a snapshot `# btrfs subvolume snapshot /snapshots/timestamp-home /mnt/@home`. Remount the (new) subvolume to its respective directory `# mount -o rw,noatime,compress-force=zstd:3,nodiscard,subvol=@home /dev/mapper/root /home`. For restoring the root @ subvolume, preferably use a live medium instead of running from current system.

Note: Many snapshots can cause performance issues. Periodically delete older snapshots from `# btrfs subvolume list /`.

9. Create systemd units for running weekly BTRFS scrubs in /etc/systemd/system/ to log datarot in `# journalctl -u btrfs-scrub.service`. To prevent larger drives from getting too hot during a scrub, adjust `IOReadBandwidthMax`.

```
/etc/systemd/system/btrfs-scrub.timer
-------------------------------------
[Unit]
Description = BTRFS scrub timer
Documentation = man:btrfs-subvolume(8)

[Timer]
OnCalendar = weekly
AccuracySec = 2d
Persistent = true

[Install]
WantedBy = timers.target
```

```
/etc/systemd/system/btrfs-scrub.service
---------------------------------------
[Unit]
Description = Perform a BTRFS scrub
Documentation = man:btrfs-subvolume(8)
Conflicts = btrfs-snapshot@.service shutdown.target sleep.target
Before = shutdown.target sleep.target

[Service]
Type = simple
ExecStart = /bin/btrfs scrub start -B /
ExecStop = /bin/sh -ec "(/bin/btrfs scrub status / | /bin/grep finished) || /bin/btrfs scrub cancel /"
CPUSchedulingPolicy = idle
IOSchedulingClass = idle
IOReadBandwidthMax = /dev/disk/by-uuid/uuid 500M
StandardOutput = journal
StandardError = journal
SyslogIdentifier = BTRFS-scrub
```

Where `uuid` is the UUID for /dev/mapper/root. Enable the timer `# systemctl enable btrfs-scrub.timer`.

10. Reboot `$ systemctl reboot` to ensure systemd unit changes take effect.

## Userspace

1. Import keys to ~/.minisign/ & ~/.ssh/ and generate public key `$ minisign -R private_key` & `$ ssh-keygen -yvf private_key` if required. Verify ownership `$ chown ekunazanu:ekunazanu -R ~/.minisign ~/.ssh` and set permissions for private keys `$ chmod 600 ~/.minisign/minisign.key ~/.ssh/ekunazanu` and public keys `$ chmod 644 ~/.minisign/minisign.pub ~/.ssh/ekunazanu.pub`.

2. Clone this repository to the home directory `$ git clone "git@codeberg.org:ekunazanu/dotfiles.git"` to /home/ekunazanu/.

3. Install [tofi](https://aur.archlinux.org/packages/tofi) and [chayang](https://aur.archlinux.org/packages/chayang).

4. Change firefox defaults in `about:config` as

```
media.ffmpeg.vaapi.enabled -> true
browser.cache.disk.enable -> false
browser.cache.memory.enable -> true
browser.sessionstore.interval -> 60000
extensions.pocket.enabled -> false
```

5. Clone projects to local `$ mkdir Projects && cd Projects && git clone <respositories>`

## Miscellaneous

Set up miscellaneous configurations as required — eg: change firefox themes, install ublock origin, tree style tabs, translate web pages etc. Edit sway input, output and swaybar profiles and i3blocks command paths as required.
