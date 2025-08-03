#!/bin/sh
#Sets The program to execute to shell (in this case shebang (small shell)) --> "#!/bin/sh"

# =============================================================================
# DOCKER NETWORK MANAGER
# =============================================================================
# Automatically fixes containers with broken network configurations.
# 
# SETUP INSTRUCTIONS:
# 1. Define your networks in this docker-compose.yml with proper IPAM ranges
# 2. Add labels to any containers you want auto-managed:
#
#    labels:
#      - "networkmanager.managed=true" 
#      - "networkmanager.networks=NETWORK_NAME:IP_ADDRESS,NETWORK_NAME:IP_ADDRESS"

#
# EXAMPLE LABELS:
#    labels:
#      - "networkmanager.managed=true"
#      - "networkmanager.networks=homelab_network:192.168.1.1"
#      - "networkmanager.networks=homelab_network:192.168.1.2,homelab_bridge:192.168.50.1"
#
# WHAT IT FIXES:
# - Containers with broken NetworkMode pointing to non-existent containers
# - Missing network attachments for labeled containers
# - Incorrect IP assignments
# - Network configuration drift
# =============================================================================


#Pushes logs to Server for inspection
exec > >(tee /scripts/network-manager.log)
exec 2>&1

echo "=== Network Manager Starting ==="
# use apk to add docker-cli (cli = command line tools)
apk add --no-cache docker-cli
# Initialize counters for Later Logging
containers_processed=0
containers_fixed=0

# docker ps tests if Manager can communicate with docker of Server Running Container;
# >/dev/null = throws away the output as it does matter we just need to check if we can access the Servers docker
# 2>&1 = throws away any error messages
# If no connection possible exits
if ! docker ps >/dev/null 2>&1; then
    echo "ERROR: Cannot connect to Docker daemon"
    exit 1
fi
# Scans Docker for all Docker containers
managed_containers=$(docker ps -a --filter "label=networkmanager.managed=true" --format "{{.Names}}")

# Checks if any Networks were found if not exit
if [ -z "$managed_containers" ]; then
    echo "No managed containers found with networkmanager.managed=true label"
    exit 0
fi

for container in $managed_containers; do
  
  echo "Processing container: $container"
  
  containers_processed=$((containers_processed + 1))
  #Gets Labels for Fixing
  current_networks=$(docker inspect --format '{{range $net, $conf := .NetworkSettings.Networks}}{{$net}}:{{$conf.IPAddress}} {{end}}' "$container")
  
  #Echos State of Container before Fixing
  echo "--- BEFORE FIX ---"
  echo "Current networks: $current_networks"
  
  networks_label=$(docker inspect --format '{{index .Config.Labels "networkmanager.networks"}}' "$container")
  
  echo "Networks label: $networks_label"
  
  #Get all current Networks
  current_networks_list=$(docker inspect --format '{{range $net, $conf := .NetworkSettings.Networks}}{{$net}} {{end}}' "$container")
  
  # Disconnect from ALL networks ONCE before reconnecting later on
  for net in $current_networks_list; do
      echo "Disconnecting from network: $net"
      docker network disconnect "$net" "$container" 2>/dev/null || true
  done
  
  # Truncate Labels to fit further Processing
  echo "$networks_label" | tr ',' '\n' | while read network_config; do
    echo "Processing network config: $network_config"
    
    # Splits by colon to get network name and IP
    network_name=$(echo "$network_config" | cut -d':' -f1)
    ip_address=$(echo "$network_config" | cut -d':' -f2)
    
    #Echos what will be touched and changed
    echo "Fixing network: $network_name with IP: $ip_address"
  
    # 2. Connects to the correct network with correct IP
    docker network connect --ip "$ip_address" "$network_name" "$container"
  done
    
    # Restarts once after all networks are fixed
    echo "Restarting $container to ensure clean state"
    docker restart "$container"
    
    echo "--- AFTER FIX ---"
    new_networks=$(docker inspect --format '{{range $net, $conf := .NetworkSettings.Networks}}{{$net}}:{{$conf.IPAddress}} {{end}}' "$container")
    echo "New networks: $new_networks"
    
    containers_fixed=$((containers_fixed + 1))
done

echo "=== SUMMARY ==="
echo "Containers processed: $containers_processed"
echo "Containers fixed: $containers_fixed"
echo "=== Network Manager Complete ==="