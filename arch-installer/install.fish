function log
    echo "=========== $argv"
end

function chroot
    arch-chroot /mnt $argv
end

function check_error
    if test $status -ne 0
        echo "A command failed. Aborting script." >&2
        exit 1
    end
end

function read_password
    set prompt $argv[1]
    while true
        read -s -P "$prompt: " password
        echo >&2
        read -s -P "Confirm $prompt: " password_confirm
        echo >&2

        if test "$password" = "$password_confirm"
            printf '%s' $password
            return
        else
            echo "Passwords did not match! Try again."
        end
    end
end

read -P "Enter the disk to install on (e.g., /dev/sda): " disk
read -P "Enter swap amount (e.g., 8GiB): " swap_size
read -P "Enter new hostname (e.g., somehost): " desired_hostname

set root_pass (read_password "Enter new root password")
echo "root_pass $root_pass"

read -P "Enter name for user account: " user_name
set user_pass (read_password "Enter password for $user_name")
echo "user_pass $user_pass"

function preinstall
    log Pre-installation

    parted "$disk" --script mklabel msdos
    check_error
    parted "$disk" --script \
        mkpart primary linux-swap 1MiB "$swap_size" \
        mkpart primary ext4 "$swap_size" 100%
    check_error

    partprobe $disk
    check_error
    mkswap {$disk}1
    check_error
    mkfs.ext4 {$disk}2
    check_error
    mount {$disk}2 /mnt
    check_error
    swapon {$disk}1
    check_error
end

function installation
    log Installation
    pacstrap -K /mnt base linux linux-firmware intel-ucode grub fish \
        networkmanager openssh sudo which python
    check_error

    log Fstab
    genfstab -U /mnt >>/mnt/etc/fstab
    check_error
end

function setup_time
    log Time
    arch-chroot /mnt ln -sf /usr/share/zoneinfo/(curl -s http://ip-api.com/line?fields=timezone) /etc/localtime
    check_error
    arch-chroot /mnt hwclock --systohc
    check_error
end

function setup_localization
    log Localization
    sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/' /mnt/etc/locale.gen
    check_error
    arch-chroot /mnt fish -c locale-gen
    check_error
    arch-chroot /mnt fish -c 'echo "LANG=en_US.UTF-8" >/etc/locale.conf'
    check_error
    arch-chroot /mnt fish -c 'echo "KEYMAP=dvorak-programmer" >/etc/vconsole.conf'
    check_error
end

function setup_network
    log Network Configuration
    arch-chroot /mnt fish -c "echo '$desired_hostname' >/etc/hostname"
    check_error
    for service in NetworkManager sshd
        systemctl --root=/mnt enable "$service"
        check_error
    end
end

function setup_bootloader
    log Bootloader
    arch-chroot /mnt grub-install --target=i386-pc "$disk"
    check_error
    arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
    check_error
end

function setup_users
    log "Set up users"
    echo "$root_pass" | arch-chroot /mnt passwd --stdin root
    check_error
    echo "%wheel ALL=(ALL:ALL) ALL" >/mnt/etc/sudoers.d/wheel
    check_error
    arch-chroot /mnt useradd \
        --create-home \
        --groups wheel,adm,input \
        --shell /bin/fish \
        "$user_name"
    check_error
    echo "$user_pass" | arch-chroot /mnt passwd --stdin "$user_name"
    check_error
end

preinstall
installation
setup_time
setup_localization
setup_network
setup_bootloader
setup_users
