FROM ubuntu:26.04

# 1. Install QEMU, UEFI (OVMF), and TPM tools
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    qemu-system-x86 \
    qemu-utils \
    ovmf \
    swtpm \
    net-tools \
    novnc \
    python3-websockify \
    python3-numpy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. Setup Directories
WORKDIR /vm

# 3. Copy Source QCOW2 Image (Read-Only Source)
COPY win10-cua-image/win10-cua.qcow2 /vm/source.qcow2

# 4. Copy the Entrypoint Script
COPY entrypoint.sh /scripts/entrypoint.sh
RUN chmod +x /scripts/entrypoint.sh

EXPOSE 5900 3389 8006 2222 50051 50052 9090

# 5. Define Entrypoint
ENTRYPOINT ["/entrypoint.sh"]
