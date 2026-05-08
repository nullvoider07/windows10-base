#!/bin/bash
set -e

# --- Configuration ---
SOURCE_IMG="/vm/source.qcow2"
EPISODE_DISK="/run/episode.qcow2"
VARS_TEMPLATE="/usr/share/OVMF/OVMF_VARS_4M.fd"
OVMF_CODE="/usr/share/OVMF/OVMF_CODE_4M.fd"
DATA_DIR="/run/storage"
mkdir -p "$DATA_DIR"
VARS_FILE="$DATA_DIR/OVMF_VARS.fd"

export QEMU_AUDIO_DRV=none

echo "--- Windows 10 Standard Boot ---"

# 1. Create Ephemeral Overlay
echo "Creating ephemeral overlay..."
qemu-img create -f qcow2 -b "$SOURCE_IMG" -F qcow2 "$EPISODE_DISK"

# 2. Prepare UEFI Variables
if [ ! -f "$VARS_FILE" ]; then
    echo "Initializing UEFI variables..."
    cp "$VARS_TEMPLATE" "$VARS_FILE"
fi

# 2. Start TPM Emulator
mkdir -p /run/tpm
swtpm socket --tpmstate dir=/run/tpm --ctrl type=unixio,path=/run/tpm/swtpm-sock --tpm2 -d
sleep 1

# 3. Start Web Viewer
echo "Starting web viewer..."
websockify -D --web=/usr/share/novnc/ 8006 localhost:5900

echo "Booting Windows 10..."

# 5. Launch QEMU
exec qemu-system-x86_64 \
  -enable-kvm \
  -m 8G \
  -smp 4,cores=4,threads=1,sockets=1 \
  -machine q35,accel=kvm \
  -boot menu=on,splash-time=0 \
  -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+invtsc \
  -device intel-hda -device hda-output,audiodev=nomix \
  -audiodev id=nomix,driver=none \
  -drive if=pflash,format=raw,readonly=on,file="$OVMF_CODE" \
  -drive if=pflash,format=raw,file="$VARS_FILE" \
  -chardev socket,id=chrtpm,path=/run/tpm/swtpm-sock \
  -tpmdev emulator,id=tpm0,chardev=chrtpm \
  -device tpm-tis,tpmdev=tpm0 \
  -device virtio-balloon-pci,free-page-reporting=on,deflate-on-oom=on \
  -vga std \
  -object iothread,id=iothread0 \
  -device virtio-scsi-pci,id=scsi0,iothread=iothread0,num_queues=4 \
  -drive file="$EPISODE_DISK",format=qcow2,if=none,id=disk0,cache=writeback,aio=threads,discard=unmap,l2-cache-size=4M \
  -device scsi-hd,drive=disk0,bootindex=1,rotation_rate=1 \
  -netdev user,id=net0,hostfwd=tcp::3389-:3389,hostfwd=tcp::2222-:22,hostfwd=tcp::9090-:9090 \
  -device virtio-net-pci,netdev=net0,id=net0,romfile="" \
  -vnc 0.0.0.0:0 \
  -usb \
  -device usb-kbd \
  -device usb-tablet \
  -monitor tcp:0.0.0.0:4444,server,nowait \
  -qmp tcp:0.0.0.0:4445,server,nowait