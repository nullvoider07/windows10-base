# Windows 10

**AI Agent Training & Evaluation Environment**  
**Version:** 1  
**Base System:** Windows 10 Pro  
**Architecture:** x86_64  
**Last Updated:** May 2026  
**Developer:** Kartik (NullVoider)

---

## Getting Started

### Clone the Repository

The QCOW2 disk image is hosted on HuggingFace due to its size. The setup scripts handle downloading it alongside the repository files automatically. It is recommended to use the below command to clone the repository.

**Linux / macOS:**
```bash
curl -fsSL https://raw.githubusercontent.com/nullvoider07/windows10-base/master/scripts/setup-win10.sh | bash
```

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/nullvoider07/windows10-base/master/scripts/setup-win10.sh | iex
```

The scripts will clone the repository, download the QCOW2 image from HuggingFace, and place all files in the correct locations automatically. Once complete, proceed to [Installation & Deployment](#installation--deployment).

---

## Table of Contents

1. [Overview](#overview)
2. [Key Features](#key-features)
3. [Container Capabilities](#container-capabilities)
   - [Operating System](#operating-system)
   - [Development Tools](#development-tools)
   - [Remote Access](#remote-access)
4. [Technical Specifications](#technical-specifications)
   - [System Requirements](#system-requirements)
   - [Container Resource Usage](#container-resource-usage)
   - [Performance Metrics](#performance-metrics)
5. [Installation & Deployment](#installation--deployment)
   - [Prerequisites](#prerequisites)
   - [Docker Compose Deployment](#docker-compose-deployment)
   - [Testing the Container](#testing-the-container)
6. [Customizing the Image](#customizing-the-image)
7. [Installed Software](#installed-software)
8. [Development Environments](#development-environments)
9. [The-Eye Integration](#the-eye-integration)
10. [Task Executor API](#task-executor-api)
11. [Remote Access Methods](#remote-access-methods)
   - [RDP (Recommended)](#rdp-recommended)
   - [SSH Access](#ssh-access)
12. [Troubleshooting](#troubleshooting)
13. [CI/CD Integration](#cicd-integration)
14. [Reporting Issues](#reporting-issues)
15. [FAQ](#faq)
16. [License](#license)
17. [About This Project](#about-this-project)

---

## Overview

The **Windows 10 Container** is a complete Windows development environment designed for AI agent training, testing, evaluation, and deployment. It provides a full Windows desktop experience with pre-configured development tools, an integrated Task Executor REST API for coding agent evaluation, and screen capture monitoring—all within a single self-contained Docker container.

### Purpose

This container is designed for:

- **Computer Use Agent Development**: Pre-configured environment for building and testing CUA applications
- **Coding Agent Evaluation**: Integrated Task Executor REST API (port 9090) for programmatic task submission, multi-framework test scoring, lint analysis, diff capture, and ground-truth patch similarity scoring.
- **Windows Development**: Native Windows environment for developing Windows-specific applications
- **Automated Testing**: Consistent, reproducible Windows environment for CI/CD pipelines
- **Remote Development**: Full-featured Windows desktop accessible via RDP and VNC
- **Multi-Language Development**: Support for 10+ programming languages out of the box
- **Visual Monitoring**: Integrated Eye tool for screen capture and agent training data collection

### What Makes This Unique

- **Single Container Design**: Complete Windows 10 system with no external file dependencies
- **Ephemeral State**: Everything is isolated inside the container, providing clean state management
- **Virtual Disk**: 2TB of massive storage capacity.
- **RAM**: Customizable memory allocation for smooth performance (minimum 4 GB for smooth experience). 
- **Optimized Performance**: Significantly smoother than existing Windows container alternatives
- **Fully Customizable**: Configuration can be modified to improve performance based on hardware
- **Zero External Files**: Everything is self-contained
- **Developer-Ready**: Pre-installed IDEs, tools, and language runtimes
- **Task Executor API**: REST API for programmatic coding agent evaluation (port 9090)
- **Multi-Framework Scoring**: pytest, cargo, go test, jest, dotnet, JUnit — auto-detected and scored

---

## Key Features

### Operating System
✅ **Windows 10 Pro** - Latest releases  
✅ **Virtual Disk** - 2TB of massive storage capacity.  
✅ **RAM** - Customizable memory allocation for smooth performance (minimum 4 GB for smooth experience).  
✅ **Ephemeral State** - Clean isolation with no external dependencies

**Note**: The virtual storage does not mandate requirement of exactly 2TB of storage in the device running the container. The virtual disk is a growable disk, and 2TB is the cap on the virtual disk. 

### Development Tools
✅ **10+ Languages** - Python, Go, Rust, Java, C#, C++, Node.js, TypeScript, Kotlin, Scala  
✅ **VS Code** - Pre-installed with essential extensions  
✅ **Visual Studio Build Tools** - Windows development tools  
✅ **Git & Git LFS** - Version control with large file support  
✅ **PowerShell & Terminal** - Modern shell utilities

### Applications
✅ **Edge Browser** - Default web browser  
✅ **VS Code** - Feature-rich code editor  
✅ **Windows Terminal** - Modern terminal experience

### Remote Access
✅ **RDP** - Native Windows Remote Desktop (3389/TCP) - **Recommended**  
✅ **SSH** - Secure shell access (2222/TCP)  
✅ **Eye Server** - Screen capture endpoint (8080/HTTP)  
✅ **Task Executor API** - Coding agent eval REST API (9090/HTTP)

### Coding Agent Evaluation
✅ **Task Executor REST API** - Submit tasks, run tests, retrieve structured results  
✅ **Multi-Framework Test Scoring** - pytest, cargo test, go test, jest, dotnet test, JUnit/Maven/Gradle/sbt  
✅ **Lint Integration** - Soft-score linting via ruff, mypy, flake8, clippy, eslint, and more  
✅ **Diff Capture** - Records agent-produced diffs after each task run  
✅ **Reference Patch Scoring** - Ground-truth patch similarity (0.0–1.0) for patch-apply evals  
✅ **API Authentication** - Optional bearer token auth via `API_TOKEN` env variable

### Performance & Stability
✅ **Fast Boot Time** - Container ready in ~25 seconds  
✅ **Low CPU Usage** - 10-20% under normal workload  
✅ **Smooth Performance** - Optimized for regular development tasks  
✅ **Single Container** - No external files or dependencies  
✅ **KVM Acceleration** - Hardware virtualization for optimal performance

---

## Container Capabilities

### Operating System

**Windows 10 Pro**
- Complete Windows desktop experience
- Native Windows applications support
- Standard NTFS file system
- Windows security features
- Native Windows APIs and frameworks

**Storage Configuration**:
- **Virtual Disk**: 2TB capacity
- **Format**: NTFS
- **RAM**: Customizable as needed (minimum 4 GB for smooth experience).
- **CPU**: Host CPU

**Pre-installed Applications**:
- **Browser**: Brave
- **Editor**: Visual Studio Code
- **Terminal**: Windows Terminal with PowerShell
- **File Manager**: Windows Explorer
- **System Utilities**: Standard Windows utilities

### Development Tools

#### Programming Languages & Runtimes

| Language | Version | Package Manager | Notes |
|----------|---------|----------------|-------|
| **Python** | 3.14.4 | pip 26.0.1 | Default `python` command |
| **Go** | 1.26.1 | go modules | Full Go development environment |
| **Rust** | stable | cargo | System-wide installation |
| **Node.js** | 24.14.0 | npm 11.9.0 | TypeScript & tsx included |
| **Java** | 25 (latest) | - | Oracle JDK |
| **C#/.NET** | 10.0 SDK | dotnet | LTS version |
| **C/C++** | MSVC/clang | - | Visual Studio Build Tools |
| **Kotlin** | 2.3.0 | - | Compiler installed |
| **Scala** | 3.8.2 | coursier | Latest stable |
| **PowerShell** | latest | - | Pre-installed |

#### IDEs & Editors

**Visual Studio Code** (latest)

Pre-installed extensions:
- C++ Tools Extension Pack
- Docker Extension
- Java Extension Pack
- Oracle Java Extension
- .NET Runtime & C# DevKit
- GitLab Workflow & GitLens
- Go Extension
- Python Extension Pack (Pylance, debugpy, environment manager)
- Rust Analyzer
- Scala Language Server

#### Build Tools & Utilities

- **Git** (latest) - Version control with LFS support
- **Visual Studio Build Tools** - Essential development tools
- **CMake** - Cross-platform build system
- **Windows Debugger** - Debugging tools

### Remote Access

#### RDP (Port 3389) - **Recommended**

**Why RDP?**
- **Best Performance**: Native Windows protocol with hardware acceleration
- **Low Latency**: Minimal input lag for smooth development experience
- **High Quality**: Superior video quality with efficient compression
- **Full Features**: Clipboard sharing, file transfer, audio support
- **Native Integration**: Built into Windows, no client installation needed (Windows hosts)

**Configuration**:
- Port: 3389 (TCP)
- Default remote access method
- Pre-configured for optimal performance
- Audio support enabled

**Use Cases**:
- Primary development interface
- Extended coding sessions
- Full desktop interaction
- Multi-window workflows 

#### SSH (Port 2222)

**Configuration**:
- Port: 2222 (TCP)
- Secure shell access via OpenSSH
- Terminal-based access to Windows

**Use Cases**:
- Command-line operations
- File transfers via SCP/SFTP
- Remote script execution
- System administration

---

## Technical Specifications

### System Requirements

#### Minimum Requirements

| Component | Requirement | Notes |
|-----------|-------------|-------|
| **RAM** | 4 GB | Absolute minimum for container operation |
| **Disk Space** | 100 GB free | For container image and virtual disk |
| **CPU** | 4 cores | x86_64 architecture with KVM support |
| **Virtualization** | KVM enabled | Hardware virtualization must be enabled in BIOS |
| **Host OS** | Linux | Ubuntu 20.04+, Debian 11+, or similar |
| **Docker** | 24.0+ | Recent Docker version required |
| **Kernel** | 5.10+ | For proper KVM support |

#### Recommended Requirements

| Component | Recommendation | Benefit |
|-----------|---------------|---------|
| **RAM** | 8 GB | Better performance and headroom |
| **Disk Space** | 256 GB free | Ample space for projects and data |
| **CPU** | 4+ cores | Improved responsiveness |
| **Storage Type** | SSD/NVMe | Faster disk I/O operations |
| **Network** | 100 Mbps+ | Better remote access experience |

### Container Resource Usage

**Runtime Allocations**:
- **Virtual RAM**: 8 GB (allocated to Windows)
- **Virtual Disk**: 2 TB (NTFS filesystem)
- **Virtual CPU**: Host CPU
- **Network**: Bridged networking with port forwarding

**Host Resource Impact**:
- **CPU Usage**: 10-20% under normal workload
- **Memory Overhead**: ~2-3 GB for container management
- **Disk I/O**: Moderate (depends on workload)
- **Network**: Minimal overhead

### Performance Metrics

**Boot Performance**:
- **Windows Boot**: 25 seconds
- **Container Start**: Immediate
- **Desktop Ready**: Immediate after boot completion

**Runtime Performance**:
- **Idle CPU**: 5-10%
- **Normal Workload CPU**: 10-20%
- **Memory Usage**: Stable at allocated 4GB
- **Disk Performance**: Depends on host storage type

**Comparison to Alternatives**:
- **Better Performance**: 10-20% CPU usage vs higher overhead in alternatives
- **Smoother Operation**: Optimized for stability and responsiveness
- **External Files**: None required (vs. multiple external files in alternatives)
- **Customization**: Fully customizable configuration
- **State Management**: Clean ephemeral state

**Optimization Notes**:
- Current configuration is optimized for compatibility and stability
- Configuration is based on tested and confirmed safe settings
- Performance can be improved by adjusting CPU configuration to match host hardware
- Animations may cause slight performance impact 
- Regular development workflows run smoothly without issues

---

## Installation & Deployment

### Prerequisites

#### 1. Install Docker

**For Ubuntu/Debian**:
```bash
# Update package index
sudo apt-get update

# Install dependencies
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Verify installation
docker --version
docker compose version
```

**For Other Linux Distributions**:
```bash
# Fedora/RHEL/CentOS
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Arch Linux
sudo pacman -S docker docker-compose
```

**Post-Installation Steps**:
```bash
# Add your user to docker group (to run docker without sudo)
sudo usermod -aG docker $USER

# Enable Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Log out and log back in for group changes to take effect
```

#### 2. Enable KVM

**Check KVM Support**:
```bash
# Check if KVM is supported
lscpu | grep Virtualization

# Check if KVM modules are loaded
lsmod | grep kvm

# Expected output:
# kvm_intel (for Intel CPUs) or kvm_amd (for AMD CPUs)
# kvm
```

**Enable KVM**:
```bash
# Install KVM packages (Ubuntu/Debian)
sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

# For Fedora/RHEL/CentOS
sudo dnf install -y qemu-kvm libvirt virt-install bridge-utils

# Verify KVM is working
sudo kvm-ok

# Expected output:
# INFO: /dev/kvm exists
# KVM acceleration can be used
```

**Set KVM Permissions**:
```bash
# Add user to kvm group
sudo usermod -aG kvm $USER

# Verify /dev/kvm permissions
ls -l /dev/kvm

# Should show: crw-rw---- 1 root kvm

# Log out and log back in for group changes to take effect
```

**Verify KVM Access**:
```bash
# After logging back in, verify you can access KVM
groups | grep kvm

# Test KVM device access
test -r /dev/kvm && test -w /dev/kvm && echo "KVM is accessible" || echo "KVM access denied"
```

**If KVM is Not Enabled in BIOS**:
1. Restart your computer
2. Enter BIOS/UEFI settings (usually F2, F10, F12, or Del key during boot)
3. Look for virtualization settings:
   - Intel: "Intel VT-x" or "Intel Virtualization Technology"
   - AMD: "AMD-V" or "SVM Mode"
4. Enable the setting
5. Save and exit BIOS
6. Boot into Linux and verify with `kvm-ok`

### Docker Compose Deployment

**Recommended Deployment Method**: The **ONLY** recommended way to run this container is using Docker Compose. This ensures proper configuration and port mappings.

#### 1. Create Docker Compose File

Create a file named `deploy-windows.yaml`:

```yaml
services:
  win-agent:
    image: nullvoider/win10-base:v1
    container_name: win_agent
    restart: unless-stopped
    tty: true
    stdin_open: true
    ports:
      - 3389:3389      # RDP (recommended remote access)
      - 4444:4445      # I/O
      - 8080:8080      # Eye server
      - 9090:9090      # Task Executor API
      - 2222:2222      # SSH
    environment:
      - API_TOKEN=your-secret-token
      - TASK_MAX_AGE=3600
    devices:
      - /dev/kvm:/dev/kvm
    cap_add:
      - NET_ADMIN
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

#### 2. Deploy the Container

```bash
# Start the container
docker compose -f deploy-windows.yaml up -d

# View logs
docker compose -f deploy-windows.yaml logs -f

# Check container status
docker compose -f deploy-windows.yaml ps
```

#### 3. Container Management

```bash
# Stop the container
docker compose -f deploy-windows.yaml stop

# Start the container
docker compose -f deploy-windows.yaml start

# Restart the container
docker compose -f deploy-windows.yaml restart

# Remove the container
docker compose -f deploy-windows.yaml down

# Remove container and volumes
docker compose -f deploy-windows.yaml down -v
```

### Testing the Container

#### 1. Verify Container is Running

```bash
# Check container status
docker ps | grep win_agent

# Expected output:
# CONTAINER ID   IMAGE                        STATUS          PORTS
# abc123def456   nullvoider/win10-base:v1   Up 2 minutes    0.0.0.0:3389->3389/tcp, ...
```

#### 2. Check Boot Progress

```bash
# Monitor container logs
docker logs -f win_agent

# Look for successful boot messages indicating:
# - Windows boot sequence completed
# - Services started
# - RDP server ready
```

#### 3. Test Remote Access

**RDP (Recommended)**:
```bash
# From Windows host:
# Press Win+R, type: mstsc
# Connect to: your-server-ip:3389

# From Linux host:
# Use Remmina, xfreerdp, or rdesktop
xfreerdp /v:your-server-ip:3389 /u:AgentUser
```

**SSH**:
```bash
# Test SSH connection
ssh -p 2222 AgentUser@your-server-ip
```

#### 4. Verify Services

Once connected via RDP:
1. Open PowerShell or Command Prompt
2. Check system information: `systeminfo`
3. Verify development tools: `python --version`, `node --version`, etc.
4. Open VS Code to verify it's installed

#### 5. Health Check

```bash
# Check container resource usage
docker stats win_agent

# Expected metrics:
# CPU: 10-20% (normal workload)
# MEM: ~4GB allocated
# NET I/O: Varies based on remote access usage
```

---

## Customizing the Image

This section walks through the full process of modifying the Windows 10 environment and rebuilding a custom Docker image — useful for adding languages, tools, updated scripts, or any workflow-specific configurations and customizations.

### Prerequisites

- Repository cloned with QCOW2 downloaded (see [Getting Started](#getting-started))
- Docker and QEMU utilities installed (`qemu-img` must be on PATH)
- At least 100 GB free disk space for the conversion steps

---

### Step 1 — Modify the YAML Configuration (Optional)

If you need to adjust the RAM or CPU core allocation before booting into Windows 10, edit the YAML file inside the `scripts/` directory of the cloned repo:

```bash
# Example: open and edit the YAML before moving it
nano scripts/win10.yaml
```

Then move it to a separate working directory of your choice — this directory will be your build workspace for all subsequent steps:

```bash
mv scripts/win10.yaml /your/working/directory/
```

> ⚠️ **WARNING**: Only change RAM and CPU core values in the YAML. **Do not change the disk size** — altering the disk size will corrupt `data.img` and make it unusable. If that happens, you will need to re-run Step 2 from the original QCOW2 file to start over.

---

### Step 2 — Convert the QCOW2 to a Raw Image

From the root of the cloned repository, convert the QCOW2 disk image to a raw format that QEMU can use as a mutable disk:

```bash
qemu-img convert -p -f qcow2 -O raw win10-image/win10.qcow2 data.img
```

This may take several minutes depending on your disk speed. The `-p` flag shows progress.

---

### Step 3 — Create the Windows 10 Directory Structure

Navigate to the working directory where you moved the YAML file and create the expected directory layout:

```bash
cd /your/working/directory
mkdir windows10-storage
```

---

### Step 4 — Place the Disk Images

Copy or move `base.dmg` and the `data.img` produced in Step 2 into the directory you just created:

```bash
# Copy (safe — preserves originals)
cp /path/to/data.img windows10-storage/data.img

# Or move (saves disk space if originals are no longer needed)
mv /path/to/data.img windows10-storage/data.img
```

---

### Step 5 — Boot and Customize

Start the container from your working directory:

```bash
docker compose -f win10.yaml up -d
```

Connect via NoMachine or VNC and perform your customizations inside the running Windows 10 environment — updating the Task Executor script, installing apps, adding programming languages, configuring tools, or anything else your workflow requires.

---

### Step 6 — Clean Up Before Capture

Before shutting down, ensure the Windows 10 environment is clean so no personal or session data ends up in your image:

- **Browser**: Close all tabs and clear all browsing history, cookies, and cached data in every browser installed
- **Terminal**: Wipe shell history — in the Powershell/Cmd terminal run `Remove-Item (Get-PSReadlineOption).HistorySavePath`
- **Recent items**: Clear recent files, recent apps, and recent servers from file explorer quick access and app search.
- **Trash**: Empty the Trash

---

### Step 7 — Shut Down and Stop the Container

Shut down Windows cleanly from within the OS (Win Key → Power button → Shut Down or Alt+F4 → Shut Down) and wait for the guest to fully power off. Then, from the host terminal in your working directory:

```bash
docker compose -f win10.yaml down
```

---

### Step 8 — Convert Back to QCOW2

From the `windows10-storage/` directory, convert the modified raw image back to a compressed QCOW2:

```bash
cd windows10-storage
qemu-img convert -p -O qcow2 -c data.img win10.qcow2
```

The `-c` flag enables compression to keep the image size manageable. This step may take several minutes.

---

### Step 9 — Move the QCOW2 to the Build Directory

Move the new QCOW2 back into the `windows10-storage/` directory of the cloned repository. If a QCOW2 already exists there, remove it first:

```bash
# Remove existing if present
rm /path/to/cloned-repo/win10-image/win10.qcow2

# Move new QCOW2 into place
mv windows10-storage/win10.qcow2 /path/to/cloned-repo/windows10-storage/win10.qcow2
```

---

### Step 10 — Build Your Custom Image

From the root of the cloned repository, build the Docker image with your chosen tag:

```bash
docker build -f win10-base.dockerfile -t <username>/<image-name>:<version-number> .
```

Example:
```bash
docker build -f win10-base.dockerfile -t myorg/win10-custom:v1 .
```

Once the build completes, clear the Docker builder cache to avoid storage bloat:

```bash
docker builder prune --all
```

Your custom image is ready to use in your workflow.

---

## Installed Software

### Pre-installed Applications

#### Productivity & Development
- **Brave** - Default web browser
- **Visual Studio Code** - Feature-rich code editor with extensions
- **Windows Terminal** - Modern terminal with PowerShell

#### System Utilities
- **Windows Explorer** - File manager
- **Settings** - Windows settings
- **Task Manager** - System resource monitoring
- **Event Viewer** - System log viewer

### Command Line Tools

#### Package Managers
- **pip** - Python package manager
- **npm** - Node.js package manager
- **cargo** - Rust package manager
- **go modules** - Go dependency management

#### Development Utilities
- **git** - Version control (with Git LFS)
- **PowerShell** - Default shell
- **Windows Terminal** - Modern terminal experience

#### Build Tools
- **Visual Studio Build Tools** - Essential development tools
- **MSVC** - Microsoft C/C++ compiler
- **make** / **nmake** - Build automation
- **cmake** - Cross-platform build system

---

## Development Environments

### Python Development
```powershell
# Python 3.14.4 pre-installed
python --version

# Install packages
pip install numpy pandas tensorflow

# Virtual environments
python -m venv myenv
myenv\Scripts\activate
```

### Node.js Development
```powershell
# Node.js 24.14.0 pre-installed
node --version
npm --version

# Install packages
npm install -g typescript tsx

# Project setup
npm init -y
npm install express
```

### Go Development
```powershell
# Go 1.26.1 pre-installed
go version

# Initialize module
go mod init myproject

# Install dependencies
go get github.com/gin-gonic/gin
```

### Rust Development
```powershell
# Rust stable pre-installed
rustc --version
cargo --version

# Create new project
cargo new myproject
cd myproject
cargo build
```

### Java Development
```powershell
# Java 25 pre-installed
java --version
javac --version

# Compile and run
javac HelloWorld.java
java HelloWorld
```

### C#/.NET Development
```powershell
# .NET 10.0 SDK pre-installed
dotnet --version

# Create new project
dotnet new console -n MyApp
cd MyApp
dotnet run
```

### Windows Development
```powershell
# Visual Studio Build Tools available
msbuild -version

# Build tools
cl.exe  # MSVC compiler
link.exe  # Linker
```

---

## The-Eye Integration

The Eye is an AI-native vision capture tool integrated into the Windows container, providing automated screen capture capabilities for Computer Use Agent training, monitoring, and debugging.

### Overview

The Eye captures screen content at configurable intervals for:
- **Agent Training**: Collect visual data for training CUAs
- **Debugging**: Record agent interactions for troubleshooting
- **Monitoring**: Track agent behavior during execution
- **Dataset Creation**: Build machine learning datasets from screen captures

### Configuration

**Eye Server Port**: 8080 (HTTP)  
**Architecture**: Client-server model with RESTful API  
**Storage**: In-memory circular buffer (configurable capacity)

### Connection & Endpoints

**Eye Server Base URL**:
```
http://your-server-ip:8080
```

**Available Endpoints**:
- `GET /health` - Server health status and metrics
- `GET /snapshot.png` - Retrieve latest captured frame
- `POST /upload` - Upload captured frames (for external agents)
- `POST /admin/config` - Update capture configuration
- `GET /debug` - Server runtime statistics

### Python SDK

The Eye includes a Python SDK for programmatic access:

**Installation** (if not using container's built-in Eye):
```bash
pip install eye-capture
```

**Basic Usage**:
```python
from eye.core import EyeClient

# Connect to Eye server
client = EyeClient("http://localhost:8080", token="your-token")

# Health check
health = client.health_check()

# Get latest screenshot
image_data = client.get_snapshot()
with open("screenshot.png", "wb") as f:
    f.write(image_data)

# Get frame metadata
metadata = client.get_snapshot_metadata()
print(f"Frame ID: {metadata['frame_id']}")

# Get debug info
debug = client.get_debug_info()
print(f"Uptime: {debug['uptime_sec']}s")
```

**Advanced Features**:
```python
from eye.core import EyeClient, SessionManager
from eye.integrations import DatasetExporter

# Initialize components
client = EyeClient("http://localhost:8080", token="TOKEN")
exporter = DatasetExporter()

# Capture session
for i in range(100):
    frame = client.get_snapshot()
    metadata = client.get_snapshot_metadata()
    exporter.add_frame(frame, i, metadata)
    time.sleep(1.5)

# Export dataset
exporter.export_json("training_data.json")
exporter.export_csv("training_data.csv")
```

### Key Features

**Capture Capabilities**:
- Multiple image formats (PNG, JPEG, WebP, BMP, TIFF)
- Configurable quality (1-100)
- Adjustable capture interval (0.1s minimum)
- Automatic retries with exponential backoff

**API Features**:
- RESTful HTTP endpoints
- Token authentication
- Dynamic configuration updates
- Health monitoring
- Debug statistics

**Integration Options**:
- Python SDK for programmatic access
- REST API for any language
- Dataset export (JSON, JSONL, CSV)
- Webhook support for event notifications
- Cloud storage integration patterns

### Quick Usage Examples

**REST API (PowerShell)**:
```powershell
# Get latest screenshot
Invoke-WebRequest -Uri http://localhost:8080/snapshot.png -OutFile screenshot.png

# Check health
Invoke-RestMethod -Uri http://localhost:8080/health

# Update configuration
$body = @{
    interval = 2.0
    format = "jpeg"
    quality = 85
} | ConvertTo-Json

Invoke-RestMethod -Uri http://localhost:8080/admin/config `
    -Method Post `
    -Headers @{"Authorization"="Bearer your-token"} `
    -Body $body `
    -ContentType "application/json"
```

**Python SDK**:
```python
from eye.core import EyeClient

client = EyeClient("http://localhost:8080")

# Continuous monitoring
while True:
    snapshot = client.get_snapshot()
    # Process snapshot for agent training
    process_for_training(snapshot)
    time.sleep(1.5)
```

### Performance Impact

- **CPU Overhead**: <3% during capture
- **Memory Usage**: 50-150 MB (in-memory buffer)
- **Network Bandwidth**: 0.5-2 MB/s @ 1.5s interval
- **Capture Latency**: 10-50ms (platform dependent)
- **Display Performance**: No noticeable impact on Windows GUI

### Configuration Options

The Eye service runs automatically when the container starts. Configure via API:

```python
import requests

# Update capture settings
response = requests.post(
    "http://localhost:8080/admin/config",
    headers={"Authorization": "Bearer your-token"},
    json={
        "interval": 2.0,      # Capture every 2 seconds
        "format": "jpeg",     # Use JPEG format
        "quality": 85         # 85% quality
    }
)
```

**For more details**, Refer to The Eye documentation: https://github.com/nullvoider07/the-eyes

---

## Task Executor API

### Overview

The Task Executor (`task_executor_windows.py`, port 9090) is the evaluation harness for frontier coding agents running on the Windows environment. It provides a REST API for submitting coding tasks, running test suites inside isolated workspaces, optionally linting the result, capturing the agent's diff, and returning structured scores — all without requiring a human operator.

Each task lifecycle: clone a repository, check out a base commit, apply the agent's patch, run the test command, lint (optional), capture the diff, score against a reference patch (optional), clean up. Results are retrievable at any time via task ID.

**Windows-specific implementation details:**
- Task workspace root: `C:\Users\AgentUser\tasks\`
- Process tree termination on timeout: `taskkill /F /T /PID` — terminates all child processes, the Windows equivalent of POSIX `SIGKILL` on a process group
- All git operations use list-form args (no shell interpolation) to prevent command injection
- `test_command` and `lint_command` run with `shell=True` inside the container, which is expected for Windows command strings

---

### Starting the Task Executor

Start the executor from PowerShell inside the container (via RDP or SSH):

```powershell
# With auth token and custom port
$env:API_TOKEN = "your-secret-token"
$env:API_PORT  = "9090"
python C:\Users\AgentUser\task_executor_windows.py
```

Verify from inside the container:
```powershell
Invoke-RestMethod -Uri http://localhost:9090/task/submit `
  -Method Post `
  -Headers @{"Authorization"="Bearer your-secret-token"; "Content-Type"="application/json"} `
  -Body '{"repo_url":"invalid","test_command":"exit 0"}'
```

Verify from host or remote orchestrator:
```bash
curl -X POST http://your-server-ip:9090/task/submit \
  -H "Authorization: Bearer your-secret-token" \
  -H "Content-Type: application/json" \
  -d '{"repo_url":"invalid","test_command":"exit 0"}'
```

---

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `TASK_BASE_DIR` | `C:\Users\AgentUser\tasks` | Root directory for task workspaces and the executor log |
| `API_PORT` | `9090` | Port the Task Executor binds to |
| `API_TOKEN` | *(unset)* | Bearer token for all requests; auth disabled when unset |
| `TASK_MAX_AGE` | `3600` | Seconds after completion before task records are evicted from memory |

Set these in the Docker Compose file under `environment:` or export them in the shell before starting the executor.

---

### Authentication

When `API_TOKEN` is set, every request must include:

```
Authorization: Bearer <token>
```

Requests without a valid token return `401 Unauthorized`. For isolated k8s pods with network-level access control, leave `API_TOKEN` unset to disable auth.

---

### REST API Reference

#### POST /task/submit

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `repo_url` | string | Yes | Git-clonable URL |
| `test_command` | string | Yes | Shell command run from repo root |
| `base_commit` | string | No | Commit/tag/branch to check out (default: `HEAD`) |
| `patch` | string | No | Unified diff applied via `git apply` |
| `timeout` | int | No | Seconds before process tree is killed (default: `300`) |
| `lint_command` | string | No | CLI lint command; result is a soft score only |
| `capture_diff` | bool | No | Capture `git diff <base_commit>` after tests (default: `false`) |
| `reference_patch` | string | No | Ground-truth diff for similarity scoring |

**Example — pytest with lint (PowerShell)**:
```powershell
$body = @{
    repo_url     = "https://github.com/psf/requests"
    base_commit  = "v2.31.0"
    patch        = "<agent unified diff>"
    test_command = "python -m pytest tests -x --tb=short"
    timeout      = 300
    lint_command = "ruff check . --output-format json"
    capture_diff = $true
} | ConvertTo-Json

Invoke-RestMethod -Uri http://your-server-ip:9090/task/submit `
  -Method Post `
  -Headers @{"Authorization"="Bearer your-secret-token"; "Content-Type"="application/json"} `
  -Body $body
```

**Example — SWE-bench style with reference patch (curl)**:
```bash
curl -X POST http://your-server-ip:9090/task/submit \
  -H "Authorization: Bearer your-secret-token" \
  -H "Content-Type: application/json" \
  -d '{
    "repo_url":        "https://github.com/example/repo",
    "base_commit":     "abc123",
    "patch":           "<agent patch>",
    "test_command":    "python -m pytest tests\\test_feature.py",
    "reference_patch": "<ground truth patch>",
    "capture_diff":    true
  }'
```

Returns `202 Accepted`: `{"task_id": "<uuid>", "status": "pending"}`

---

#### GET /task/\<task_id\>

Lightweight status poll. Returns `task_id` and `status` only (`pending` → `running` → `completed` | `failed`).

```bash
curl http://your-server-ip:9090/task/<task_id> \
  -H "Authorization: Bearer your-secret-token"
```

---

#### GET /task/\<task_id\>/result

Returns `202` while running. Returns `200` on completion with the full result record:

| Field | Type | Description |
|-------|------|-------------|
| `exit_code` | int | Exit code of the test command |
| `stdout` | string | Combined stdout from all steps |
| `stderr` | string | Combined stderr from all steps |
| `tests_passed` | int | Passing test count |
| `tests_failed` | int | Failing/errored test count |
| `lint_errors` | int or null | Lint error count; `null` if no `lint_command` |
| `lint_output` | string or null | Raw linter stdout+stderr |
| `patch_diff` | string or null | `git diff <base_commit>` output; `null` if not requested |
| `patch_similarity` | float or null | 0.0–1.0 vs `reference_patch`; `null` if no reference provided |
| `execution_time` | float | Wall-clock seconds from start to finish |

```bash
curl http://your-server-ip:9090/task/<task_id>/result \
  -H "Authorization: Bearer your-secret-token" | jq .
```

---

#### DELETE /task/\<task_id\>

Removes the task record from memory. Does not cancel a running task — submit with a short `timeout` value to cancel effectively.

---

### Supported Test Frameworks

| `test_command` contains | Framework |
|------------------------|-----------|
| `pytest`, `py.test` | pytest |
| `cargo` | cargo test |
| `go test` | go test |
| `jest`, `npm test`, `yarn test`, `pnpm test` | Jest |
| `dotnet` | dotnet test |
| `mvn`, `gradle`, `sbt`, `junit` | JUnit/Surefire |

For unrecognised commands, all parsers are tried in order and the first non-zero result is used.

---

### Supported Linters (Soft Score)

| Linter | Language | Example `lint_command` |
|--------|----------|------------------------|
| `ruff` | Python | `ruff check . --output-format json` |
| `flake8` | Python | `flake8 src` |
| `mypy` | Python | `mypy src --ignore-missing-imports` |
| `pylint` | Python | `pylint src` |
| `cargo clippy` | Rust | `cargo clippy -- -D warnings` |
| `eslint` | JS/TS | `eslint src --format json` |
| `go vet` | Go | `go vet ./...` |
| `dotnet build` | C# | `dotnet build --no-restore` |

Lint results are always soft — `lint_errors` is recorded but never changes `status` or `exit_code`. This is consistent with the convention used by SWE-bench, HumanEval, and LiveCodeBench.

---

### Remote Polling Pattern

```python
import time, requests

BASE    = "http://your-server-ip:9090"
HEADERS = {"Authorization": "Bearer your-secret-token"}

# Submit
r = requests.post(f"{BASE}/task/submit", headers=HEADERS, json={
    "repo_url":     "https://github.com/example/repo",
    "test_command": "python -m pytest tests -x",
    "lint_command": "ruff check .",
    "capture_diff": True,
})
task_id = r.json()["task_id"]

# Poll (5s interval is reasonable given Windows boot latency)
while True:
    s = requests.get(f"{BASE}/task/{task_id}", headers=HEADERS).json()
    if s["status"] not in ("pending", "running"):
        break
    time.sleep(5)

# Retrieve full result
result = requests.get(f"{BASE}/task/{task_id}/result", headers=HEADERS).json()
print(f"Passed: {result['tests_passed']}  Failed: {result['tests_failed']}  "
      f"Lint: {result['lint_errors']}  Similarity: {result['patch_similarity']}")

# Clean up
requests.delete(f"{BASE}/task/{task_id}", headers=HEADERS)
```


---

## Remote Access Methods

### RDP (Recommended)

**Primary Remote Access Method**: RDP provides the best performance and native Windows integration.

#### Why RDP?

**Performance Benefits**:
- Native Windows protocol
- Hardware-accelerated rendering
- Optimized for Windows GUI
- Low latency input handling
- Efficient bandwidth usage
- Superior video quality

**Features**:
- Full desktop experience
- Audio support
- Multi-session support
- Printer redirection
- Drive mapping

#### Connection Setup

**From Windows Host**:
1. Press `Win + R`
2. Type `mstsc`
3. Enter: `your-server-ip:3389`
4. Click Connect

**From Linux Host**:
```bash
# Using xfreerdp
xfreerdp /v:your-server-ip:3389 /u:AgentUser /smart-sizing

# Using Remmina (Recommended)
remmina

# Using rdesktop
rdesktop your-server-ip:3389
```

**From macOS Host**:
- Download Microsoft Remote Desktop from App Store
- Add PC: `your-server-ip:3389`
- Connect

#### Best Practices

**For Best Performance**:
- Use wired network connection when possible
- Close unused applications in the container
- Disable unnecessary visual effects in Windows settings
- Use RemoteFX for enhanced graphics (if supported)

**Network Requirements**:
- Minimum: 10 Mbps
- Recommended: 100 Mbps+
- Latency: <50ms for best experience

#### Use Cases

**Primary Development**:
- Extended coding sessions
- Full IDE usage (VS Code, Visual Studio)
- Multi-window workflows
- Windows application development

**Testing & Debugging**:
- Interactive debugging
- Visual testing
- GUI automation development
- Screen recording

### SSH Access

**Port**: 2222

#### Connection

```bash
# Basic SSH connection
ssh -p 2222 AgentUser@your-server-ip

# With key authentication
ssh -i ~/.ssh/id_rsa -p 2222 AgentUser@your-server-ip

# Port forwarding example
ssh -L 8080:localhost:8080 -p 2222 AgentUser@your-server-ip
```

#### Use Cases

**Command-Line Operations**:
- PowerShell script execution
- Package installation
- System administration
- Log viewing

**File Transfer**:
```bash
# Copy files to container
scp -P 2222 file.txt AgentUser@your-server-ip:C:\Users\AgentUser\

# Copy files from container
scp -P 2222 AgentUser@your-server-ip:C:\file.txt ./

# Using rsync (with WSL or Cygwin)
rsync -avz -e "ssh -p 2222" ./local-dir AgentUser@your-server-ip:/cygdrive/c/remote-dir
```

**Remote Script Execution**:
```bash
# Execute single command
ssh -p 2222 AgentUser@your-server-ip "python script.py"

# Execute PowerShell script
ssh -p 2222 AgentUser@your-server-ip "powershell -File script.ps1"
```

---

## Troubleshooting

### Common Issues

#### 1. Windows Update Interference

**Symptoms**:
- Unexpected reboots
- Performance degradation during updates
- Services stopped after boot

**Solutions**:

**Disable Automatic Updates**:
```powershell
# Open PowerShell as Administrator
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1

# Or use Services.msc
# Disable "Windows Update" service
```

#### 2. Slow Performance

**Symptoms**:
- Lag during window operations
- Slow application response
- High CPU usage

**Cause**:
- Windows background services

**Solutions**:

**Option 1: Optimize Visual Effects**:
1. Open System Properties (Win + Pause)
2. Advanced system settings → Performance Settings
3. Select "Adjust for best performance"
4. Or manually disable animations

**Option 2: Disable Background Services**:
```powershell
# Disable Windows Search
Stop-Service -Name "WSearch" -Force
Set-Service -Name "WSearch" -StartupType Disabled

# Disable Superfetch
Stop-Service -Name "SysMain" -Force
Set-Service -Name "SysMain" -StartupType Disabled
```

**Note: Do not disable services and scheduled task for AutoHotKey and the-eyes tool. They are essential for actuation and capture for CUA.**

**Option 3: Configuration Adjustment** (Advanced):
- Configuration can be customized for better performance
- Requires understanding of system limits and testing

#### 3. Container Won't Start

**Symptoms**:
- Container exits immediately after start
- Error messages in logs
- Container status shows "Exited"

**Diagnostic Steps**:
```bash
# Check container logs
docker logs win_agent

# Check container status
docker ps -a | grep win_agent

# Inspect container
docker inspect win_agent
```

**Common Solutions**:

**KVM Not Available**:
```bash
# Verify KVM is accessible
ls -l /dev/kvm

# Check if you're in kvm group
groups | grep kvm

# Add user to kvm group if missing
sudo usermod -aG kvm $USER
# Log out and back in
```

**Insufficient Resources**:
```bash
# Check available RAM
free -h

# Check disk space
df -h

# Verify at least 4GB RAM available
```

**Port Conflicts**:
```bash
# Check if ports are already in use
sudo netstat -tlnp | grep -E '3389|4000|8080|9090|2222'

# Stop conflicting services or change ports in docker-compose.yaml
```

#### 4. Remote Access Connection Issues

**RDP Won't Connect**:
```bash
# Verify port is exposed
docker port win_agent 3389

# Check if service is listening
docker exec win_agent netstat -an | findstr 3389

# Test connectivity from host
telnet localhost 3389
```

**SSH Connection Refused**:
```bash
# Check SSH port mapping
docker port win_agent 2222

# Verify SSH service
docker exec win_agent powershell "Get-Service sshd"
```

#### 5. Windows-Specific Issues

**Standard Windows Troubleshooting Applies**:

Most Windows-related issues can be resolved using standard Windows troubleshooting methods:

1. **System Settings Reset**:
   - Open Settings
   - Reset specific settings causing issues
   - Restart affected applications

2. **Application Issues**:
   - Use Task Manager to end unresponsive programs
   - Clear application caches

3. **Disk Issues**:
   - Run `chkdsk`
   - Check available storage space
   - Defragment if needed (though SSD doesn't need it)

4. **Permission Issues**:
   - Run applications as Administrator
   - Check file/folder permissions
   - Use `icacls` to fix permissions

**These are standard Windows issues, not container-specific problems**.

### Getting Help

If you encounter issues not covered here:

1. **Check container logs**: `docker logs win_agent`
2. **Review system resources**: Ensure minimum requirements are met
3. **Verify KVM access**: Confirm `/dev/kvm` is accessible
4. **Test connectivity**: Check network and port accessibility
5. **See Reporting Issues section** for how to get support

---

## CI/CD Integration

The Windows container is designed for seamless integration into CI/CD pipelines, particularly for Computer Use Agent development and deployment.

### Supported Platforms

**Container Orchestration**:
- ✅ **Docker** - Native Docker deployment
- ✅ **Kubernetes** - K8s pod deployment
- ✅ **Docker Compose** - Multi-container orchestration
- ✅ **Docker Swarm** - Swarm service deployment

**CI/CD Systems**:
- GitHub Actions
- GitLab CI/CD
- Jenkins
- CircleCI
- Travis CI
- Azure DevOps
- Any system supporting Docker

### Docker-Based CI/CD

#### GitHub Actions Example

```yaml
name: Windows Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up KVM
        run: |
          sudo apt-get update
          sudo apt-get install -y qemu-kvm libvirt-daemon-system
          sudo usermod -aG kvm $USER
      
      - name: Start Windows Container
        run: |
          docker compose -f deploy-windows.yaml up -d
          sleep 25  # Wait for boot
      
      - name: Run Tests
        run: |
          docker exec win_agent powershell -File tests/test_agent.ps1
      
      - name: Cleanup
        if: always()
        run: docker compose -f deploy-windows.yaml down
```

#### GitLab CI Example

```yaml
stages:
  - test

windows_tests:
  stage: test
  image: docker:latest
  services:
    - docker:dind
  variables:
    DOCKER_DRIVER: overlay2
  before_script:
    - docker info
  script:
    - docker compose -f deploy-windows.yaml up -d
    - sleep 25
    - docker exec win_agent powershell -File tests/test_agent.ps1
  after_script:
    - docker compose -f deploy-windows.yaml down
  tags:
    - kvm
```

### Kubernetes Deployment

#### Pod Specification

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: windows-agent
  labels:
    app: windows
spec:
  containers:
  - name: win-agent
    image: nullvoider/win10-base:v1
    ports:
    - containerPort: 3389
      name: rdp
    - containerPort: 4444
      name: I/O
    - containerPort: 8080
      name: eye-server
    - containerPort: 9090
      name: task-executor
    - containerPort: 2222
      name: ssh
    securityContext:
      capabilities:
        add:
        - NET_ADMIN
    volumeMounts:
    - name: kvm
      mountPath: /dev/kvm
  volumes:
  - name: kvm
    hostPath:
      path: /dev/kvm
      type: CharDevice
  restartPolicy: Always
```

#### Deployment with Service

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: windows-agent-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: windows
  template:
    metadata:
      labels:
        app: windows
    spec:
      containers:
      - name: win-agent
        image: nullvoider/win10-base:v1
        ports:
        - containerPort: 3389
        - containerPort: 4444
        - containerPort: 8080
        - containerPort: 9090
        - containerPort: 2222
---
apiVersion: v1
kind: Service
metadata:
  name: windows-agent-service
spec:
  selector:
    app: windows
  ports:
  - name: rdp
    port: 3389
    targetPort: 3389
  - name: I/O
    port: 4444
    targetPort: 4445
  - name: eye
    port: 8080
    targetPort: 8080
  - name: task-executor
    port: 9090
    targetPort: 9090
  - name: ssh
    port: 2222
    targetPort: 2222
  type: LoadBalancer
```

### Use Cases

**AI Agent Development**:
- Automated testing of CUA implementations
- Training data collection in reproducible environments
- Performance benchmarking
- Benchmarking of coding agent capabilities
- Integration testing

**Windows Application Testing**:
- Cross-platform application testing
- Windows-specific feature validation
- GUI automation testing
- Compatibility verification

**Continuous Integration**:
- Automated builds on Windows environment
- Unit testing with Windows dependencies
- Integration testing with Windows services
- End-to-end testing workflows

### Best Practices

**Resource Management**:
```yaml
# Kubernetes resource limits
resources:
  requests:
    memory: "4Gi"
    cpu: "4"
  limits:
    memory: "8Gi"
    cpu: "4"
```

**Health Checks**:
```yaml
# Kubernetes liveness probe
livenessProbe:
  tcpSocket:
    port: 3389
  initialDelaySeconds: 120
  periodSeconds: 30
```

**Cleanup Strategy**:
- Always use `docker compose down` or equivalent cleanup
- Implement timeout for long-running tests
- Monitor resource usage during CI runs
- Use ephemeral runners when possible

---

## Reporting Issues

When reporting issues, please provide comprehensive information to help diagnose and resolve problems quickly.

### Bug Reports

**Required Information**:

1. **Environment Details**:
   ```bash
   # Docker version
   docker --version
   docker compose version
   
   # Host OS information
   cat /etc/os-release
   uname -a
   
   # KVM information
   kvm-ok
   ls -l /dev/kvm
   ```

2. **System Resources**:
   ```bash
   # Available RAM
   free -h
   
   # Disk space
   df -h
   
   # CPU information
   lscpu
   ```

3. **Container Logs**:
   ```bash
   # Full container logs
   docker logs win_agent > container-logs.txt
   
   # Last 200 lines
   docker logs --tail 200 win_agent
   
   # Real-time logs
   docker logs -f win_agent
   ```

4. **Container Status**:
   ```bash
   # Container details
   docker ps -a | grep win_agent
   docker inspect win_agent
   
   # Resource usage
   docker stats win_agent --no-stream
   ```

5. **Steps to Reproduce**:
   - Detailed steps to reproduce the issue
   - Expected behavior
   - Actual behavior
   - Screenshots or screen recordings if applicable

6. **Configuration**:
   - Docker Compose file contents
   - Any custom modifications
   - Environment variables used

### Feature Requests

**Required Information**:

1. **Use Case Description**:
   - What problem does this feature solve?
   - Who would benefit from this feature?
   - How urgent is this feature?

2. **Proposed Implementation**:
   - How should the feature work?
   - What configuration options should it have?
   - Any technical considerations?

3. **Impact Assessment**:
   - How would this affect existing functionality?
   - Resource implications (CPU, RAM, disk)?
   - Compatibility considerations?

4. **Alternatives Considered**:
   - What alternatives have you considered?
   - Why is this approach preferred?

### Contact Information

**For Direct Support**:
- **X (Formerly Twitter)**: [@nullvoider07](https://x.com/nullvoider07)

**When Reporting**:
- Be specific and detailed
- Include all requested information
- Attach logs and screenshots
- Describe impact and urgency

---

## Security Considerations

### Default Configuration

- Runs with `NET_ADMIN` capability and KVM device access
- Auto-login enabled for development convenience
- Remote services (RDP, SSH) with configurable credentials
- KVM passthrough requires direct device access

For production deployments, review the hardening notes below.

### Task Executor API Security

- Set `API_TOKEN` for all non-isolated deployments
- Bind port 9090 to localhost when the orchestrator is on the same host:
  ```yaml
  ports:
    - "127.0.0.1:9090:9090"
  ```
- `test_command` and `lint_command` run with `shell=True` — ensure the submitting agent or orchestrator is trusted
- Access the Task Executor from external networks via SSH tunnel:
  ```bash
  ssh -L 9090:localhost:9090 -p 2222 AgentUser@your-server-ip
  ```
  Then submit tasks to `http://localhost:9090`
- Pass `API_TOKEN` as a k8s Secret — never hardcode in Compose files

### General Hardening

1. Use `NET_ADMIN` capability only
2. Create a dedicated Docker network for agent containers
3. Use environment files or k8s Secrets for all tokens
4. Rebuild the image periodically to incorporate Windows updates
5. Enable Docker json-file logging with rotation
6. Only grant necessary permissions


---

## FAQ


### Coding Agent Evaluation Questions

**Q: What is the Task Executor API?**
A: It is a REST API (`task_executor_windows.py`) running on port 9090 that provides programmatic task submission, multi-framework test scoring, lint analysis, diff capture, and ground-truth patch similarity scoring. It is the primary eval harness for coding agents running on Windows.

**Q: How do I start the Task Executor?**
A: From PowerShell inside the container (via RDP or SSH): set `API_TOKEN` and `API_PORT` environment variables, then run `python C:\Users\AgentUser\task_executor_windows.py`. See the Task Executor API section for details.

**Q: Why is lint scoring soft — why does it not fail the task?**
A: The majority of established coding benchmarks (SWE-bench, HumanEval, LiveCodeBench) use test pass/fail as the primary correctness signal. Lint errors reflect code quality but not functional correctness. Keeping lint soft lets you track quality trends without invalidating otherwise correct solutions.

**Q: What is patch_similarity and when is it useful?**
A: It is a 0.0–1.0 similarity ratio between the agent's actual diff and a ground-truth reference patch, computed after stripping all unified diff metadata. Most useful for patch-apply evals where a canonical solution exists. Always interpret alongside `tests_passed` — a lower similarity score does not mean the solution is wrong.

**Q: Can the Task Executor run tasks in parallel?**
A: Yes. Each submitted task runs in an independent background thread with its own isolated workspace under `TASK_BASE_DIR`. For large-scale parallelism, deploy multiple container replicas via k8s — each replica maintains its own in-memory task store.

**Q: What happens if a task times out?**
A: The executor runs `taskkill /F /T /PID`, which forcefully terminates the entire process tree rooted at the test process. The task is marked `failed` with the timeout error recorded in `stderr`.

**Q: How do I access the Task Executor remotely?**
A: The Task Executor binds to `0.0.0.0:9090`. In a k8s deployment, expose it via a `ClusterIP` service for internal orchestrator access, or `NodePort`/`LoadBalancer` for external access. Always set `API_TOKEN` when the port is reachable outside a trusted network boundary.

**Q: In a k8s deployment with many replicas, how does an orchestrator route tasks to a specific container?**
A: Each replica runs its own Task Executor with its own in-memory task store. Track the pod IP (or headless service DNS entry) at submission time and send all status/result polls to the same pod. A load-balanced service may route requests to different replicas and return `404 Task not found`.

**Q: What happens to in-flight tasks if a pod is evicted or restarted?**
A: In-flight tasks are lost — the in-memory store does not survive a restart. Implement retry logic in your orchestrator and treat `404 Task not found` as a signal to resubmit. The Windows container's ~25-second boot adds latency to recovery; account for this in orchestrator timeout settings.

**Q: How do I pass API_TOKEN securely across a k8s cluster?**
A: Mount it as a k8s `Secret`:
```yaml
env:
  - name: API_TOKEN
    valueFrom:
      secretKeyRef:
        name: task-executor-secret
        key: api-token
```
Never hardcode tokens in the Compose file or Dockerfile.

### General Questions

**Q: How is the entire Windows system running in a single container?**  
A: This container uses advanced virtualization techniques with KVM acceleration to run a complete Windows system. The implementation has everything self-contained within the container image. The result is a fully functional Windows 10 environment that's completely isolated and ephemeral.

**Q: Why doesn't this container need external files?**  
A: The container architecture was designed from the ground up to be self-contained. All necessary components, including the Windows system files, bootloader, and configuration, are embedded within the container image itself. This provides significant advantages: easier deployment, cleaner state management, no external file dependencies, and true ephemeral operation.

**Q: Can I run multiple instances of this container?**  
A: Yes, but each instance requires 4GB of RAM. Ensure your host has sufficient resources (e.g., 8GB+ RAM free for 2 instances).

**Q: How much disk space does it need?**  
A: The container image requires approximately 100GB of host disk space. The Windows system inside has a 2TB virtual disk.

**Q: Is this suitable for production use?**  
A: Yes, it's specifically designed for Computer Use Agent development, coding agents, and deployment in production environments. The container provides a stable, reproducible Windows environment ideal for CI/CD pipelines and automated testing.

### Performance Questions

**Q: Why is the boot time 25 seconds?**  
A: This includes the complete Windows boot sequence, service initialization, and remote access server setup. This is normal for a full Windows system and is competitive with bare-metal Windows boot times.

**Q: Can I improve the performance?**  
A: Yes, the current host CPU configuration can be customized for better performance based on your hardware. The existing configuration prioritizes stability and compatibility. You can adjust the CPU configuration, though this requires testing on your specific hardware.

**Q: Why does RDP perform better on Windows?**  
A: RDP is the native Windows remote desktop protocol and is optimized specifically for Windows GUI rendering. It uses hardware acceleration and efficient protocols designed for Windows systems.

**Q: What's the CPU usage under heavy load?**  
A: Under normal development workloads (coding, browsing, terminal work), expect 20-30% CPU. Heavy compilation or resource-intensive applications may increase this to 40-50%.

### Compatibility Questions

**Q: Does it work on Windows/macOS hosts?**  
A: It requires a Linux host with KVM support. Windows (WSL2 with nested virtualization) and macOS hosts are not officially supported due to KVM requirements.

**Q: What Linux distributions are supported?**  
A: Any modern Linux distribution with Docker 24.0+ and KVM support:
- Ubuntu 20.04+
- Debian 11+
- Fedora 36+
- CentOS 8+
- Arch Linux

**Q: Can I use AMD CPUs?**  
A: Yes, as long as AMD-V (SVM) is enabled in BIOS and the KVM kernel modules are loaded.

**Q: What about ARM processors (Apple Silicon)?**  
A: Not supported. This is an x86_64 container designed for Intel/AMD processors only.

### Configuration Questions

**Q: Can I change the RAM allocation?**  
A: Yes, but currently the container is configured for 8GB RAM. Changing this requires rebuilding the container image with modified configuration.

**Q: Can I use this for .NET development?**  
A: Yes, .NET SDK and Visual Studio Build Tools are pre-installed. The container is optimized for Computer Use Agent and Coding agent development but fully supports .NET workflows.

**Q: How do I persist data across container restarts?**  
A: Use Docker volumes to mount directories from the host:
```yaml
volumes:
  - ./my-projects:C:\Users\AgentUser\projects
```

### Remote Access Questions

**Q: Which remote access method should I use?**  
A: Use RDP for best performance — it is the native Windows protocol with hardware acceleration and full clipboard/audio support. Use SSH for headless command-line operations, script execution, and file transfers.

**Q: Can I use other remote desktop solutions?**  
A: The container is pre-configured with RDP and VNC. Adding other solutions would require custom configuration.

**Q: What's the bandwidth requirement for RDP?**  
A: Minimum 10 Mbps, recommended 100 Mbps+ for best experience. Less bandwidth will work but may impact video quality.

### Troubleshooting Questions

**Q: Windows Updates are interfering. What should I do?**  
A: Disable automatic updates via Group Policy or Services. See Troubleshooting section for detailed steps.

**Q: Why is performance slow?**  
A: The host CPU configuration prioritizes stability. You can disable visual effects, unnecessary services, or customize the CPU configuration for better performance.

**Q: How do I access container logs?**  
A:
```bash
docker logs win_agent
docker logs -f win_agent  # Follow mode
```

**Q: The container won't start. What's wrong?**  
A: Check:
1. KVM is accessible (`ls -l /dev/kvm`)
2. Sufficient RAM available (8GB free)
3. Ports aren't conflicting
4. Docker service is running
5. Container logs for specific errors

### Security Questions

**Q: Is this container secure?**  
A: The container runs with NET_ADMIN capability and requires KVM access. It's designed for development environments. For production, review security considerations and implement appropriate network isolation.

**Q: Can I run this in a public cloud?**  
A: Only on infrastructure that exposes hardware virtualization extensions to the guest. Bare-metal instances work universally. Standard VM instances require the cloud provider to explicitly enable nested virtualization — AWS Nitro, Google Cloud, and Azure support it on select instance types, but it must be enabled per-instance and is not on by default. The limiting factor is the hypervisor configuration, not the host OS.

**Q: How do I secure remote access?**  
A: Use VPN or SSH tunneling to access the container:
```bash
ssh -L 3389:localhost:3389 -p 2222 host-server
```
Then connect RDP to `localhost:3389`.

---

## License

This project is licensed under the **GNU General Public License v3.0 (GPL-3.0)**.

### What GPL-3.0 Covers

The GPL-3.0 license applies to:
- Container configuration files and Docker Compose setup
- Custom scripts and automation tools created by the developer
- Integration code and custom components
- Documentation and setup instructions
- Any modifications you make to these components

### GPL-3.0 License Summary

**Permissions**:
- ✅ Commercial use
- ✅ Modification
- ✅ Distribution
- ✅ Patent use
- ✅ Private use

**Conditions**:
- 📋 License and copyright notice
- 📋 State changes
- 📋 Disclose source
- 📋 Same license (copyleft)

**Limitations**:
- ❌ Liability
- ❌ Warranty

### What This Means

**For the Container Infrastructure** (GPL-3.0):
- You can use, modify, and distribute the container configuration
- You can create derivative works of the setup scripts
- If you distribute modified versions, you must:
  - Include the GPL-3.0 license
  - Make your source code modifications available
  - License your modifications under GPL-3.0
  - Document any changes made

### Full License

For the complete license text, see: https://www.gnu.org/licenses/gpl-3.0.en.html

### Disclaimer

This container is provided "as is" without warranty of any kind.

---

## About This Project

The **Windows 10 Container** represents a significant advancement in containerized Windows environments. Built for Computer Use Agent development and frontier coding agent evaluation, this project addresses the key challenges faced by developers working with Windows-based automation and AI agents.

Version 1 extends the original CUA environment into a full coding agent evaluation platform. The Task Executor API — covering multi-framework test scoring, programmatic lint integration, diff capture, and ground-truth patch similarity scoring — was built to support rigorous coding agent benchmarking on a native Windows runtime, a capability absent from Linux-only eval frameworks.

### Project Goals

**Primary Objectives**:
- Provide a reproducible Windows environment for AI coding agents and CUA development
- Eliminate external file dependencies for cleaner deployments
- Optimize performance while maintaining stability
- Enable seamless CI/CD integration for Windows workflows
- Support scalable agent training and testing

**Design Philosophy**:
- **Self-Contained**: Everything in one container, no external files
- **Ephemeral**: Clean state management with proper isolation
- **Performant**: Optimized for real-world development workflows
- **Tested**: Based on confirmed safe and stable configurations
- **Accessible**: Simple deployment with Docker Compose

### Development Journey

This container was built from the ground up through:
- Extensive testing on real hardware
- Iterative performance optimization
- Configuration tuning for stability
- Integration of development tools
- Refinement of remote access methods

Every configuration choice, from the host CPU setting to the 8GB RAM allocation, is based on tested and confirmed performance characteristics. The current configuration represents what can be safely delivered and has been verified to work reliably.

### Why This Matters

**For Developers**:
- Consistent Windows environment across team members
- No "works on my machine" issues
- Fast setup and deployment
- Integrated development tools
- Built-in monitoring capabilities

**For Organizations**:
- Reproducible testing environments
- CI/CD pipeline integration
- Scalable agent deployment
- Cost-effective Windows access
- Clean resource management

### Future Direction

While the current configuration is optimized for compatibility and stability, the container is designed to be customizable. As hardware capabilities evolve and use cases expand, configurations can be adjusted to leverage more powerful systems while maintaining the core benefits of containerization.

### Acknowledgments

This project builds on the containerization ecosystem and the work of many in the Docker and virtualization communities. Special recognition to:
- The Docker team for container technology
- The KVM project for virtualization
- The open-source community for tools and libraries

### Get Involved

**Feedback & Contact**:
- **X (Twitter)**: [@nullvoider07](https://x.com/nullvoider07)
- Report issues with detailed information
- Share your use cases and experiences
- Suggest improvements and features

**Contributing**:
The core implementation details is open-source, feedback on the mentioned topics and other topics not in the list:
- Performance optimization suggestions
- Use case requirements
- Bug reports and fixes
- Documentation improvements

**Key files:**
- `task_executor_windows.py` — Task Executor REST API server
- `deploy-windows.yaml` — Docker Compose deployment file
- `README.md` — This documentation

...is always welcome and appreciated.

---

**Last Updated:** May 2026  
**Version:** 1  
**Developer:** Kartik (NullVoider)  
**License:** GPL-3.0

---

**Windows 10** - Full Windows in one self-contained container. AI agent training and evaluation, no compromises, no external files. 🚀