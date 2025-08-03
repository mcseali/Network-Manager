# Network-Manager



A lightweight, automated solution for fixing Docker container network configurations. Perfect for homelabs running multiple containers with complex networking requirements.



\## What It Does



Automatically detects and fixes common Docker networking issues:

\- \*\*Broken NetworkMode\*\* configurations pointing to non-existent containers

\- \*\*Missing network attachments\*\* for containers that should be on multiple networks

\- \*\*Incorrect IP assignments\*\* due to configuration drift

\- \*\*Network configuration inconsistencies\*\* after system updates



\## Perfect For Homelabs



Especially useful for:

\- \*\*Synology NAS\*\* users running Container Manager

\- \*\*Multi-network setups\*\* (macvlan + bridge networks)

\- \*\*Complex services\*\* like Pi-hole, Nginx Proxy Manager, Home Assistant

\- \*\*Preventing downtime\*\* after DSM updates or container recreations



\## How It Works:



1\. \*\*Scans containers\*\* with management labels

2\. \*\*Compares current state\*\* vs intended configuration

3\. \*\*Automatically fixes\*\* network attachments and IP assignments

4\. \*\*Provides detailed logging\*\* of what was changed

5\. \*\*Restarts containers\*\* to ensure clean network state



\## --- Quick Setup ---



\### 1. Deploy the Network Manager:



&nbsp;  ```bash

&nbsp;  # Clone this repository

&nbsp;  git clone https://github.com/yourusername/docker-network-manager.git

&nbsp;  cd docker-network-manager

&nbsp;  

&nbsp;  # Edit compose.yaml to match your network setup

&nbsp;  # Update IP ranges, subnets, and gateway addresses

&nbsp;  

&nbsp;  # Deploy

&nbsp;  docker-compose up

&nbsp;  ```



\### 2. Label Your Containers:



&nbsp;  Add these labels to containers you want managed:

&nbsp;  

&nbsp;  ```yaml

&nbsp;  services:

&nbsp;    your-service:

&nbsp;      labels:

&nbsp;        - "networkmanager.managed=true"

&nbsp;        - "networkmanager.networks=your\_network:192.168.1.100"

&nbsp;      # For multiple networks:

&nbsp;        - "networkmanager.networks=network1:192.168.1.100,network2:192.168.2.100"

&nbsp;  ```



\### 3. Run When Needed:



&nbsp;  ```bash

&nbsp;  # Fix all managed containers

&nbsp;  docker-compose up

&nbsp;  

&nbsp;  # Check the logs

&nbsp;  cat scripts/network-manager.log

&nbsp;  ```



\## Examples:



&nbsp;  ### Basic Container (Single Network):

&nbsp;  ```yaml

&nbsp;  services:

&nbsp;    nginx-proxy-manager:

&nbsp;      container\_name: nginx-proxy-manager

&nbsp;      image: jc21/nginx-proxy-manager:latest

&nbsp;      labels:

&nbsp;        - "networkmanager.managed=true"

&nbsp;        - "networkmanager.networks=homelab\_network:192.168.1.50"

&nbsp;      networks:

&nbsp;        homelab\_network:

&nbsp;          ipv4\_address: 192.168.1.50

&nbsp;  ```

&nbsp;  

&nbsp;  ### Advanced Container (Multiple Networks):

&nbsp;  ```yaml

&nbsp;  services:

&nbsp;    pihole:

&nbsp;      container\_name: pihole

&nbsp;      image: pihole/pihole:latest

&nbsp;      labels:

&nbsp;        - "networkmanager.managed=true"

&nbsp;        - "networkmanager.networks=homelab\_network:192.168.1.198,homelab\_bridge:192.168.1.2"

&nbsp;      networks:

&nbsp;        homelab\_network:

&nbsp;          ipv4\_address: 192.168.1.198

&nbsp;        homelab\_bridge:

&nbsp;          ipv4\_address: 192.168.1.2

&nbsp;  ```



\## --- Configuration ---



\### Network Setup

1\. Edit `compose.yaml`

2\. Update network configurations to match your environment:

&nbsp;  - \*\*Subnet\*\*: Your network range (e.g., `192.168.1.0/24`)

&nbsp;  - \*\*IP Range\*\*: Container IP allocation range (e.g., `192.168.1.100/29`)

&nbsp;  - \*\*Gateway\*\*: Your router IP (e.g., `192.168.1.1`)



\### Container Labels

\- `networkmanager.managed=true` - Enables management for this container

\- `networkmanager.networks=NETWORK:IP,NETWORK:IP` - Defines intended network configuration



\##  --- When You Need This ---



\### Common Scenarios:

\- \*\*After NAS updates\*\* (Synology DSM, UNRAID, etc.)

\- \*\*Container image updates\*\* that recreate containers

\- \*\*Adding new services\*\* to ensure proper networking

\- \*\*Network configuration changes\*\* across multiple containers

\- \*\*System reboots\*\* or Docker daemon restarts



\### Signs You Have Network Issues:

\- Containers can't reach external hosts

\- Services lose connectivity after updates

\- Multi-network containers missing some network attachments

\- `docker inspect` shows weird NetworkMode values



\## --- Sample Output ---



```

=== Network Manager Starting ===

Processing container: pihole

--- BEFORE FIX ---

Current networks: homelab\_bridge:192.168.1.2 

Networks label: homelab\_network:192.168.1.198,homelab\_bridge:192.168.1.2

Disconnecting from network: homelab\_bridge

Processing network config: homelab\_network:192.168.1.198

Fixing network: homelab\_network with IP: 192.168.1.198

Processing network config: homelab\_bridge:192.168.1.2

Fixing network: homelab\_bridge with IP: 192.168.1.2

Restarting pihole to ensure clean state

--- AFTER FIX ---

New networks: homelab\_bridge:192.168.1.2 homelab\_network:192.168.1.198 

✅ Container pihole processed



=== SUMMARY ===

Containers processed: 1

Containers fixed: 1

=== Network Manager Complete ===

```



\## --- Security ---



\- \*\*Read-only Docker socket access\*\* - only inspects and manages networks

\- \*\*No external network access\*\* - runs entirely on your local Docker host

\- \*\*Minimal container\*\* - uses Alpine Linux base image

\- \*\*Transparent logging\*\* - all actions logged for audit



\## --- Contributing ---



Issues and pull requests welcome! This started as a homelab solution and grew into something that might help others.



\## --- License ---



MIT License - feel free to use and modify for your homelab needs.



\## --- Acknowledgments ---



Born from the frustration of manually fixing Docker networking after every Synology DSM update.



---



