# 🔄 MikroTik Loop Protection & Broadcast Storm Stopper

![Platform](https://img.shields.io/badge/Platform-MikroTik%20RouterOS-red)
![Mechanism](https://img.shields.io/badge/Mechanism-TTL%20Hack%20%7C%20Horizon-blue)
![Safety](https://img.shields.io/badge/Safety-Loop%20Prevention-green)

## 🆘 The Problem
A network loop occurs when a cable is accidentally plugged back into the same switch or network segment.
- **Symptoms:** High CPU usage, massive packet loss, Interface traffic spiking to max capacity (Broadcast Storm).
- **Failure:** Sometimes STP (Spanning Tree) is too slow or disabled on cheap switches.

## 🛠️ The Solution
This repository applies a multi-layer defense strategy:
1.  **TTL Hack (Layer 3):** Reduces the "Time to Live" of packets entering from customers to 1. If they try to loop it back, the packet dies instantly.
2.  **Bridge Horizon (Layer 2):** Prevents a port from forwarding traffic to other ports in the same "Horizon" group.
3.  **BPDU Guard:** Blocks malicious spanning tree packets.

## 🚀 Installation Guide

### Step 1: Apply Loop Prevention Script
Upload `loop_killer.rsc` and import it.
```bash
/import loop_killer.rsc

Step 2: Configure Bridge Horizon (Manual)
If you have multiple LAN ports bridged:
/interface bridge port set [find interface=ether2] horizon=1
/interface bridge port set [find interface=ether3] horizon=1

Ports with the same Horizon ID cannot talk to each other directly, preventing L2 loops.

⚠️ Warning
The TTL Hack prevents customers from using their own routers to share internet (Tethering/NAT) deeper into their network. Use it only if you want to restrict unauthorized sub-networks.

Author: Sheikh Alamin Santo
Network Reliability Engineer (NRE)
