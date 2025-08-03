# 🐳 Docker Network Manager

A lightweight, automated solution for fixing Docker container network configurations. Perfect for homelabs running multiple containers with complex networking requirements.

## 🎯 What It Does

Automatically detects and fixes common Docker networking issues:

- **🔧 Broken NetworkMode** configurations pointing to non-existent containers
- **🔗 Missing network attachments** for containers that should be on multiple networks  
- **📍 Incorrect IP assignments** due to configuration drift
- **⚡ Network configuration inconsistencies** after system updates

## 🏠 Perfect For Homelabs

Especially useful for:

- **📦 Synology NAS** users running Container Manager
- **🌐 Multi-network setups** (macvlan + bridge networks)
- **🛠️ Complex services** like Pi-hole, Nginx Proxy Manager, Home Assistant
- **🚫 Preventing downtime** after DSM updates or container recreations

## ⚙️ How It Works

1. **🔍 Scans containers** with management labels
2. **📊 Compares current state** vs intended configuration
3. **🔄 Automatically fixes** network attachments and IP assignments
4. **📝 Provides detailed logging** of what was changed
5. **🔄 Restarts containers** to ensure clean network state

## 🚀 Quick Setup

### 1. Deploy the Network Manager

```bash
# Clone this repository
git clone https://github.com/Duneram/Network-Manager.git
cd Network-Manager

# Edit compose.yaml to match your network setup
# Update IP ranges, subnets, and gateway addresses

# Deploy
docker-compose up
```

### 2. Label Your Containers

Add these labels to containers you want managed:

```yaml
services:
  your-service:
    labels:
      - "networkmanager.managed=true"
      - "networkmanager.networks=your_network:192.168.1.100"
    # For multiple networks:
      - "networkmanager.networks=network1:192.168.1.100,network2:192.168.2.100"
```

### 3. Run When Needed

```bash
# Fix all managed containers
docker-compose up

# Check the logs
cat scripts/network-manager.log
```

## 📚 Examples

### Basic Container (Single Network)

```yaml
services:
  nginx-proxy-manager:
    container_name: nginx-proxy-manager
    image: jc21/nginx-proxy-manager:latest
    labels:
      - "networkmanager.managed=true"
      - "networkmanager.networks=homelab_network:192.168.1.50"
    networks:
      homelab_network:
        ipv4_address: 192.168.1.50
```

### Advanced Container (Multiple Networks)

```yaml
services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    labels:
      - "networkmanager.managed=true"
      - "networkmanager.networks=homelab_network:192.168.1.198,homelab_bridge:192.168.1.2"
    networks:
      homelab_network:
        ipv4_address: 192.168.1.198
      homelab_bridge:
        ipv4_address: 192.168.1.2
```

## 🔧 Configuration

### Network Setup

1. Edit `compose.yaml`
2. Update network configurations to match your environment:
   - **🌐 Subnet**: Your network range (e.g., `192.168.1.0/24`)
   - **📍 IP Range**: Container IP allocation range (e.g., `192.168.1.100/29`)
   - **🚪 Gateway**: Your router IP (e.g., `192.168.1.1`)

### Container Labels

- `networkmanager.managed=true` - Enables management for this container
- `networkmanager.networks=NETWORK:IP,NETWORK:IP` - Defines intended network configuration

## 🚨 When You Need This

### Common Scenarios

- **🔄 After NAS updates** (Synology DSM, UNRAID, etc.)
- **📦 Container image updates** that recreate containers
- **➕ Adding new services** to ensure proper networking
- **🔧 Network configuration changes** across multiple containers
- **🔄 System reboots** or Docker daemon restarts

### Signs You Have Network Issues

- ❌ Containers can't reach external hosts
- 🔌 Services lose connectivity after updates
- 🌐 Multi-network containers missing some network attachments
- 🔍 `docker inspect` shows weird NetworkMode values

## 📊 Sample Output

```text
=== Network Manager Starting ===
Processing container: pihole
--- BEFORE FIX ---
Current networks: homelab_bridge:192.168.1.2 
Networks label: homelab_network:192.168.1.198,homelab_bridge:192.168.1.2
Disconnecting from network: homelab_bridge
Processing network config: homelab_network:192.168.1.198
Fixing network: homelab_network with IP: 192.168.1.198
Processing network config: homelab_bridge:192.168.1.2
Fixing network: homelab_bridge with IP: 192.168.1.2
Restarting pihole to ensure clean state
--- AFTER FIX ---
New networks: homelab_bridge:192.168.1.2 homelab_network:192.168.1.198 
✅ Container pihole processed

=== SUMMARY ===
Containers processed: 1
Containers fixed: 1
=== Network Manager Complete ===
```

## 🔒 Security

- **👁️ Read-only Docker socket access** - only inspects and manages networks
- **🏠 No external network access** - runs entirely on your local Docker host
- **🪶 Minimal container** - uses Alpine Linux base image
- **📋 Transparent logging** - all actions logged for audit

## 🤝 Contributing

Issues and pull requests welcome! This started as a homelab solution and grew into something that might help others.

## 📄 License

MIT License - feel free to use and modify for your homelab needs.

## 🙏 Acknowledgments

Born from the frustration of manually fixing Docker networking after every Synology DSM update. If this saves you time, consider sharing your own homelab solutions ^^

---
