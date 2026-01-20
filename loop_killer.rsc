```rsc
# ============================================================
# Emergency Script 5: Loop Protection & Anti-Storm
# Author: Sheikh Alamin Santo
# Use Case: Stops Broadcast Storms and Routing Loops
# ============================================================

/interface bridge settings
set use-ip-firewall=yes

# --- 1. Block BPDU (Prevent Unauthorized Switches) ---
# Stops users from plugging in switches that mess up STP topology.
/interface bridge filter
add action=drop chain=input dst-mac-address=01:80:C2:00:00:00/FF:FF:FF:FF:FF:FF \
    comment="Drop STP BPDU packets from customers"

# --- 2. The TTL Hack (Layer 3 Loop Prevention) ---
# If a packet comes from a customer, set TTL to 1.
# If they try to route it back (Loop), TTL becomes 0 and packet is dropped.
# CAUTION: This also blocks customers from using routers behind your connection.
# Enable strictly for "Single PC" users or loop-prone zones.

/ip firewall mangle
add action=change-ttl chain=prerouting in-interface-list=LAN new-ttl=set:1 \
    passthrough=yes comment="Anti-Loop: Set TTL to 1"

# --- 3. Broadcast Storm Control ---
# Limits how many broadcast packets can enter the router per second.
/interface bridge filter
add action=drop chain=forward packet-type=broadcast limit=100,5:packet \
    comment="Limit Broadcast Storms"

:log info "Loop Protection Shields Activated!"
