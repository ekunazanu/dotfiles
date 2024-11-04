Backup to set up an encrypted Arch on a [USB drive](https://wiki.archlinux.org/index.php/Install_Arch_Linux_on_a_removable_medium#Tips) (bootable on both BIOS and UEFI preferably). Quick checklist to set it up fast, in case I forget the password again and have to reinstall arch. Still [to-do](#todos). PS. If someone else is reading this, **please refer to the official ArchWiki.** As you might have noticed most of these are outlinks to the wiki anyways. It's for a reason.

## Base Installation
1. [Setting up gpt table and partitioning disk](https://wiki.archlinux.org/index.php/GPT_fdisk#Create_a_partition_table_and_partitions) with [this layout](#disk-layout)

2. [Setting up LUKS Container, Logical Volumes](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS)

2b.1 [Setting LUKS Container on BTRFS filesystem](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#Btrfs_subvolumes_with_swap)

2b.2 Make a ```btrfs``` filesystem on cryptdevice using ``` mkfs.btrfs -L "label" --csum xxhash /dev/device```. [Possible checksum algorithms](https://man.archlinux.org/man/btrfs.5#CHECKSUM_ALGORITHMS)

2b.3 btrfs mount options include ```noatime,compress-force=zstd:1,datacow,datasum,nodiscard, space_cache=v2,ssd```. Use ```zstd:1``` in case it is an NVME drive, ```zstd:2``` for a SATA SSD, and ```zstd:*(default)*``` for HDDs, since CPU calculation for compression can be a bottleneck. ```noatime``` cane be reverted back to ```relatime``` in case apps mishave and need to know access times. ```sdd``` in case you are using an SSD.

2b.4 Create btrfs subvolumes by first mounting the cryptdevice and then running ``` btrfs subvolume create /mountpoint/{@,@home,@snapshots,@var}```.

2b.5 Unmount the *cryptdevice* and then remount the *subvolumes* using mount options  ```mount -o noatime,compress-force=zstd:1,datacow,datasum,nodiscard,space_cache=v2,ssd,subvol=@ /dev/mapper/cryptdevice /mountpoint/``` and the same for ```subvol={@home,snapshots,var}``` to be mounted at ```{/mountpoint/home,/mountpoint/snapshots,/mountpoint/var}```. Make sure the mount options persist in the generated fstab of new installation media.

3. [Backing up and restoring LUKS Header](https://wiki.archlinux.org/index.php/Dm-crypt/Device_encryption#Backup_and_restore)

4. [Installing base Arch](https://wiki.archlinux.org/index.php/Installation_guide#Installation) with [these packages](#packages)

5. For initramfs hooks,<sup>[1](https://wiki.archlinux.org/index.php/Install_Arch_Linux_on_a_removable_medium#Installation_tweaks) [2](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Configuring_mkinitcpio_2)</sup> <br />
```HOOKS=(base udev block keyboard keymap autodetect consolefont modconf encrypt lvm2 filesystems fsck)```<br />
```HOOKS=(base systemd autodetect keyboard sd-vconsole modconf block sd-encrypt sd-lvm2 filesystems fsck)```<br />
*(Don't forget to rebuild initramfs)*

6. To install GRUB for both systems, <sup>[1](https://wiki.archlinux.org/index.php/GRUB#Installation) [2](https://wiki.archlinux.org/index.php/GRUB#Installation_2) [3](https://wiki.archlinux.org/index.php/Install_Arch_Linux_on_a_removable_medium#GRUB)</sup> <br />
```# grub-install --target=i386-pc /dev/sdx --recheck```<br />
```# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB  --removable --recheck```

7. For GRUB config, add the [cryptdevice parameters](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Configuring_the_boot_loader_2) under ```GRUB_CMDLINE_LINUX=""``` and [disable submenu](https://wiki.archlinux.org/index.php/GRUB/Tips_and_tricks#Disable_submenu), both in ```etc/default/grub``` and regenerate /boot/grub/grub.cfg

8. Add user ```# useradd -m -G wheel -s /bin/zsh koala``` and add wheel to sudoers ```# EDITOR=nano visudo```

9. ```# passwd``` and ```# passwd koala```

## System
1. ~~To lock tty session after inactivity, make ```lock.sh``` in ```/etc/profile.d/``` and add ```TMOUT=300``` and on next line, add ```trap '[[ -z $DISPLAY ]] && physlock -p $USER' SIGALRM```~~ **This is more headache than necessary, don't do it. Just run ```vlock``` before leaving your pc**

2. keyring

3. password mananger

4. For networking, use [NetworkManager](https://wiki.archlinux.org/index.php/NetworkManager), by enabling NetworkManager.service and [disabling dhcpcd/netctl/other services](https://wiki.archlinux.org/index.php/NetworkManager#Additional_interfaces)

5. openvPN or WireGuard - https://sylvaindurand.org/setting-up-a-vpn-with-wireguard/

6. nftables - https://wiki.archlinux.org/index.php/nftables

7. power management

8. ntp

9. Update mirrorlists with ```reflector```, and enable ```reflector.service``` & ```reflector.timer```, and set ```/etc/xdg/reflector/reflector.conf```:
```
    --save /etc/pacman.d/mirrorlist
    --connection-timeout 5
    --download-timeout 5
    --protocol https
    --completion-percent 100.0
    --country de,fr,ch,nl,no,fi,be,at
    --age 2
    --score 20
    --sort rate
```

## Zsh
1. [Autologin](https://wiki.archlinux.org/index.php/getty#Automatic_login_to_virtual_console) and use ```Type=simple``` in ```/etc/systemd/system/getty.target.wants/getty\@tty1.service```

2. In ```~/.zshrc``` source files for ```zsh-syntax-highlighting``` ```zsh-autosuggestions``` ```zsh-history-substring-search``` ```zsh-theme-powerlevel10k``` in this exact order. \
```zsh-history-substring-search``` arch package is outdated and does not support "HISTORY_SUBSTRING_SEARCH_PREFIXED=1". Manually download download the [.zsh file](https://raw.githubusercontent.com/zsh-users/zsh-history-substring-search/master/zsh-history-substring-search.plugin.zsh) and optionally move it ```/usr/share/zsh/plugins/zsh-history-substring-search```to and source it.

3. Make ```~/.zprofile``` and add [this](https://wiki.archlinux.org/index.php/Sway#Autostart_on_login) to autostart sway, remove ```exec``` to keep logged in after exiting sway

### Sway & Wayland
1. Copy all the configs to  ```~/```, ```~/.config``` and other respective directories

2. To open firefox [in wayland mode](https://wiki.archlinux.org/index.php/firefox#Wayland), set environment variable ```MOZ_ENABLE_WAYLAND=1``` in ```.zshenv```

3. Export ```XDG_SESSION_TYPE=wayland``` and ```XDG_CURRENT_DESKTOP=sway``` to ```.zshenv```

4. ```LIBSEAT_BACKEND=logind``` in ```.zshenv``` in case libseat fails to connect to socket

5. In case hardware acceleration doesn't work out of the box, [set environment variables](https://wiki.archlinux.org/title/Hardware_video_acceleration#Configuration), ```LIBVA_DRIVER_NAME=i965/iHD/radeonsi/nouveau``` and ```VDPAU_DRIVER=va_gl/radeonsi/nouveau```.

6. ```MOZ_WEBRENDER=1``` in case there are performance issues (and/or CPU is not properly utilized/optimized), and ```MOZ_ACCELERATED=1``` in order to force hardware acceleration for MOZ_WEBRENDER to work in case it is disabled by default

### Extras
1. Add ```userChrome.css``` in ```~/.mozilla/firefox/(the_deafult_active_profile)/chrome/```

2. [Enable stylesheets for firefox](https://www.userchrome.org/how-create-userchrome-css.html#aboutconfig) by enabling ```toolkit.legacyUserProfileCustomizations.stylesheets``` in ```about:config```

3. Install the [firefox theme](https://addons.mozilla.org/en-US/firefox/addon/an-even-better-lime-green/) you made

4. Set ```cmus``` theme using ```:colorscheme```

5. Uncomment ```VerbosePkgLists```, ```CheckSpace```, ```Color``` and ```ParallelDownloads = 6``` in ```/etc/pacman.conf```

6. Set ```EDITOR=nvim```, ```TERMINAL=termite``` and ```BROWSER=firefox``` in ```/etc/environment```

7. In case of SSD that supports [trim](https://wiki.archlinux.org/title/Solid_state_drive#TRIM), enable ```fstrim.service```(?) and ```fstrim.timer```. In case the drive is NVME, install ```nvme-cli```, for userspace support.

### Environment Variable
The ```.zshenv``` file should end up looking like
```
EDITOR=nvim
XDG_SESSION_TYPE=wayland      
XDG_CURRENT_DESKTOP=sway
LIBSEAT_BACKEND=logind
TERMINAL=foot
BROWSER=firefox
MOZ_ENABLE_WAYLAND=1
MOZ_WEBRENDER=1
MOZ_ACCELERATED=1
```

### Disk Layout
<table>
  <tr>
    <td><b>Partitions</b></td>
	<td><b>Windows Readable Partition</b></td>
	<td colspan="2"><b>LUKS Container</b></td>
	<td><b>BIOS Grub Partition</b></td>
	<td><b>UEFI Boot Partition</b></td>
  </tr>
  <tr>
    <td><b>gdisk hex</b></td>
	<td>0700</td>
	<td colspan="2">8300</td>
	<td>ef02</td>
	<td>ef00</td>
  </tr>
    <tr>
    <td rowspan="2"><b>Block Device</b></td>
	<td>/dev/sdx1</td>
	<td colspan="2">/dev/sdx2</td>
	<td>/dev/sdx3</td>
	<td>/dev/sdx4</td>
  </tr> 
    <tr>
	<td></td>
    <td>/dev/VolumeGroup/root</td>
	<td>/dev/VolumeGroup/home</td>
	<td colspan="2"></td>
  </tr>  
    <tr>
    <td><b>File System</b></td>
	<td>FAT32/NTFS</td>
	<td>ext4</td>
	<td>ext4</td>
	<td>Unformatted</td>
	<td>FAT32</td>
  </tr> 
    <tr>
    <td><b>Mountpoint</b></td>
	<td>Not Mounted</td>
	<td>/</td>
	<td>/home</td>
	<td>Not Mounted</td>
	<td>/boot</td>
  </tr>
  <tr>
    <td rowspan="2"><b>Size</b></td>
	<td rowspan="2">As required</td>
	<td>At least 8GiB</td>
	<td>As required</td>
	<td rowspan="2">2MiB</td>
	<td rowspan="2">200MiB</td>
  </tr>
  <tr>
    <td colspan="2">(LUKS Container must accomodate size of both Logical volumes)</td>
  </tr>
</table>

* In case of a BTRFS filesystem on ```/```, there is no need for an LVM, and the entire cryptdevice can be formatted as a BTRFS filesystem. The separation between ```/``` and ```/home``` can be done using subvolumes, and a swapfile can be used instead of a swap partition.

* In case of a UEFI system (with or without GRUB), there is no need for a BIOS GRUB partition.

### Packages
##### Base
    base base-devel arch-install-scripts intel-ucode amd-ucode linux linux-lts linux-firmware man-db man-pages dosfstools (efibootmgr grub nano vilvm2 btrfs-progs snapper nvme-cli)
##### System
    git ntp(?) rsync reflector pacman-contrib openssh playerctl brightnessctl libnotify pass bat ripgrep eza btop wireplumber pavucontrol(maybe?)
#### Shell
    zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting
#### Networking
    networkmanager nm-connection-editor modemmanager mobile-broadband-provider-info usb_modeswitch networkmanager-openconnect networkmanager-openvpn openvpn openresolv dnsmasq rp-pppoe(maybe?)
#### Drivers
    mesa mesa-vdpau libva-mesa-driver libva-intel-driver intel-media-driver opencl-mesa vulkan-intel vulkan-mesa-layers vulkan-radeon libinput
##### Sway & Wayland
    xorg-server-xwayland sway swaybg swayidle swaylock waybar mako wlsunset jq grim slurp wf-recorder wl-clipboard xdg-desktop-portal-wlr kanshi cliphist xdg-utils
##### Additional Apps
    neovim lf foot firefox imv mpv yt-dlp aria2 ncspot gitui ncdu csvlens obsidian
##### Maybe
    lesspipe exa wmenu tofi(aur) tldr fzf tickrs mutt/neomutt/notmuch httpie archlinux-wallpaper tesseract tesseract-data-eng zbarimg qrencode glpaper-hg(aur) hackernews_tui wiki-tui ripgrep yazi fd pijul(aur)
##### Fonts
    adobe-source-code-pro-fonts adobe-source-sans-pro-fonts adobe-source-serif-pro-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-fira-code ttf-jetbrains-mono ttf-nerd-fonts-symbols ttf-font-awesome inter-font
##### AUR
    chayang


### Todos
- [x] Transition from i3 to sway ~~(currently in progress)~~ Done
- [x] Setup up fscrypt for home directories (Changed to dm-crypt for system-wide encryption)
- [x] ~~Configure [mlocate](https://wiki.archlinux.org/index.php/mlocate) to change frequency of updatedb in systemd timer unit~~
- [x] Check if mlocate is reuqired in the first place (yeah, not required)
- [x] Make LUKS Header backup
- [x] Filesyetem and journal modifications and optimizations for flash drives
- [x] Remove ohmyzsh
    - [ ] Remove duplicates while scrolling up/down
    - [ ] Improve hist() function: Include/Source history from .histfile rather than memory
    - [ ] Print .histfile with proper formatting timestamps and log syntax highlighting
    - [ ] [Use mouse to move cursor](https://github.com/matschaffer/oh-my-zsh-custom/blob/master/mouse.zsh)
- [x] Playerctl rewind 10 seconds keybinding
- [ ] Set up pass-otp
- [ ] Update mako config (invoking makoctl DND mode, away mode, low priority styles+timing, progress styling, etc)
- [ ] Other multiple output related configs (sway, waybar, etc)
- [ ] Improve output management mode in sway by adding mirroring and screen res, refreshrate options
- [ ] Revise sway config and add ```--release``` and ```--no-repeat``` where necessary
- [ ] Clean up waybar configs + Add proper multi-monitor indicators for workspace module
- [ ] Revise drivers and packages
- [ ] Set up hardware acceleration for firefox
- [ ] Set up hardware acceleration for wf-recorder (using hevc, preferably)
- [ ] Revise the entire repo and remove bloat from config files
- [ ] Set up btrfs (snapshots and stuff)
- [ ] Maybe auto ```pacman -Syu``` every week
- [ ] Set up snapper+(timeshit?)
- [ ] Consider switching:
	- [x] termite -> foot ~~(hoping for it to come to official repos)~~ in official repos now
    - [ ] neovim -> kakoune
	- [ ] waybar -> yambar swaybar+https://github.com/greshake/i3status-rust (maybe?)
	- [ ] wofi -> bemenu/fuzzel/wmenu/dmenu-wayland/yofi/tofi (wofi is unmaintained, so will switch, but idk to what) (in progress)
    - [ ] clipman -> cliphist (https://github.com/sentriz/cliphist)
	- [ ] pass -> something that uses symmetric encryption, preferably encrypts file structure and names too. maybe pw (https://github.com/pzl/pw)
	- [x] gammastep -> wlsunset (not in official repos yet either)
	- [x] spotify-tui -> ncspot (later ig)
        - [ ] h264 -> hevc for ```wf-recorder``` (hevc results in worse quality)
        - [ ] lame -> vorbis-tools (```oggenc - -q8 -b196 -r -o $HOME/Music/recordings/$(date +'%F-%T.mp3'```) (need to weigh pros and cons, so far, oggenc is better but, dependencies might be huge; also need to sort out optimal quality/size ratio.) Or flac(?), for lossless files.
        - [ ] Try to switch to lossless but compressed formats for audio recording/screenshots/screencasts/anything saved to disk
	- [ ] pulseaudio -> pipewire (in progress)
	- [x] ext4 -> btrfs
	- [ ] grub -> systemd-boot (in progress)
    - [ ] us -> colemak_dh or workman (yeah not happening anytime soon)
- [ ] Set up a leaner network manager
- [ ] Set up a firewall
- [ ] Set up a VPN
- [ ] Set up a keyring (and check its security to convinience ratio)
    - [ ] For GPG
    - [ ] For SSH
- [ ] Remove all koala references
    - [ ] GPG keys
    - [ ] SSH keys
    - [ ] Github repos and commit history
    - [ ] All accounts (check from passwords repository)
    - [ ] Change passwords to stop leaking emails
- [x] Set up session lock (Swaylock for wayland and physlock for tty.
- [x] Set up a password manager [used ```pass```](https://www.github.com/somelazykoala/secrets)
- [ ] Set up neovim properly
    - [ ] Autocompletion
    - [ ] Tree view on the left
    - [ ] Indent lines
- [ ] Set up Newsboat
- [ ] Set up an IRC and weechat
- [ ] Set up mailnag
- [ ] Power management
- [x] MPD and ncmpcpp (used cmus, since it's simpler, more lightweight and faster, may consider switching later tho)
- [x] Transition from Xorg to Wayland (Sway is the most likely candidate)
- [x] Figure out a way to remove Waybar-Workpace-Hover in style.css [(Workaround)](https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect)
- [x] Waybar-Workspace-Index to Bullet icons using JSON hack-workarounds (used CSS for #workspaces button.persistent)
- [x] Sway stacked layout for firefox (workspace 3)
- [ ] Make a good color scheme which can be used both at day/night (and stick to it dammit) (catpuccin and nord are candidates)
- [ ] Window screenshot binding on sway (grim) (Done, but not satisfactory; would like to take full window screenshots even if window is partially hidden by another window)
- [x] Screenshot current monitor/output
- [x] Move container to certain output
- [x] Use output audio (speakers) for wf-recorder screencasts
- [x] Fix screensharing audio (probably pipewire related) (Not a bug, not supported officialy yet)
- [ ] Primary monitor only configs (workspace-module-only waybar, mako, swaylock ring on primary monitor only) (will do when a wayland protocol for primary output is decided)
- [ ] Tofi apps: https://www.youtube.com/watch?v=v8w1i3wAKiw
    - [x] Dictionary using wofi
    - [ ] Emote selector using wofi
    - [ ] Window switching using wofi
    - [ ] Simple calc (maybe using wofi?)
    - [ ] Shazam equivalent tool
    - [ ] [Picker stuff](https://mark.stosberg.com/fuzzel-a-great-dmenu-and-rofi-altenrative-for-wayland/)
- [ ] ```--release``` for kill/floating_toggle mouse keybindings (upstream issue)
- [x] Create some gl-paper shaders
- [x] userChrome.css for firefox (Slowed down startup time and syntax keeps changing, so used themes instead)
- [ ] Revise the entire repo and remove bloat from config files
- [ ] Transition to more CLI apps
- [ ] General
    - [ ] https://wiki.archlinux.org/index.php/Improving_performance#Reduce_disk_reads.2Fwrites
    - [ ] https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks
    - [ ] https://wiki.archlinux.org/index.php/General_recommendations
    - [ ] https://wiki.archlinux.org/index.php/System_maintenance
    - [ ] https://wiki.archlinux.org/title/Firefox/Tweaks#Turn_off_the_disk_cache

### For Permanent Install (on PC)
* Windows readable partition/Windows partition need not be the first partition
* Partition and format boot partition according to need (Either just for BIOS or just for UEFI)
* Enable journaling (use defaults) for ext4 partitions
* Install GRUB for either just BIOS or UEFI, (or just use systemd-boot in case it's UEFI)
* Use [default](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Configuring_mkinitcpio_2) encrypt mkinitcpio hooks (Don't move ```blocks``` hook)
* Add a non-admin account ```# useradd -m guest``` and ```passwd guest```


Enable trim on the dm-crypt with :allow-discards after cryptdevice boot paramater see ahead efibootmgr command.

https://wiki.archlinux.org/title/Systemd-boot#systemd_service
/boot/loader/entries/arch.conf:
```
title Arch Linux
linux /vmlinuz-linux
initrd /amd-ucode.img
initrd /initramfs-linux.img
otions rd.luks.name=*UUID*=cryptroot root=/dev/mapper/cryptroot
```
/boot/loader/loader.conf:
```
default arch
timeout 2
editor 0
```

https://www.latacora.com/blog/2019/07/16/the-pgp-problem/ encrypted backups -> tarsnap
https://xoc3.io/blog/2022-12-11 -> signing -> minisign
file encryption -> age

https://www.reddit.com/r/archlinux/comments/16p9nh7/comment/k1qsqge/

firefox
> about:config
> gfx.webrender.compositor,gfx.webrender.compositor.force-enabled -> true
> full-screen-api.warning.timeout -> 0
> browser.cache.disk.enable -> false
> browser.cache.memory.enable -> true
> browser.cache.memory.capacity -> 102400
> browser.sessionstore.interval -> 60000

tlp
sudo systemctl disable/stop tlp.service
sudo systemctl unmask systemd-rfkill.service systemd-rfkill.socket

https://gitlab.freedesktop.org/wlroots/wlroots/-/merge_requests/3421 mirroring
https://github.com/swaywm/sway/issues/5758 primary output concept
https://git.sr.ht/~emersion/wlspeech + https://github.com/ggerganov/whisper.cpp stt
