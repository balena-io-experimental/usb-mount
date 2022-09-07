#!/usr/bin/env sh

# Set up mount directories
tmp_dir='/tmp/tmpmount'
mkdir -p "$tmp_dir"
mount -t devtmpfs none "$tmp_dir"
mkdir -p "$tmp_dir/shm"
mount --move /dev/shm "$tmp_dir/shm"
mkdir -p "$tmp_dir/mqueue"
mount --move /dev/mqueue "$tmp_dir/mqueue"
mkdir -p "$tmp_dir/pts"
mount --move /dev/pts "$tmp_dir/pts"
touch "$tmp_dir/console"
mount --move /dev/console "$tmp_dir/console"
umount /dev || true
mount --move "$tmp_dir" /dev

# Since the devpts is mounted with -o newinstance by Docker, we need to make
# /dev/ptmx point to its ptmx.
# ref: https://www.kernel.org/doc/Documentation/filesystems/devpts.txt
ln -sf /dev/pts/ptmx /dev/ptmx

# Mount the debug directory
mount -t debugfs nodev '/sys/kernel/debug'

{
  # Trigger a check for devices already connected to initiate mounting process
  # Requires UDEV to start before being able to listen for events
  sleep 4
  udevadm trigger --action add --subsystem-match=block --type=devices --property=DEVTYPE=partition
}&    

# Start UDEV and wait for usb devices to be added
echo "Listening for new USB devices..."

# Running in debug mode to allow log echoing from scripts
exec udevd --debug
