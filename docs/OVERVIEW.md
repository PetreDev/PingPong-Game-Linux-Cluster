# Project Overview - N02 Linux Cluster

## 🏗️ Architecture Diagram

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Host Computer │    │  Docker Engine  │    │   Containers    │
│   (Computer 0)  │────│                 │────│                 │
│                 │    │ Network:        │    │ • ssh-container-1│
│ • N02.txt       │    │   172.21.0.0/16 │    │   IP: 172.21.0.2 │
│ • SSH keys      │    │                 │    │                 │
│ • Commands      │    │ • Bridge Network│    │ • ssh-container-2│
└─────────────────┘    │ • IP Assignment │    │   IP: 172.21.0.3 │
                       └─────────────────┘    │                 │
                                               │ • ssh-container-3│
                                               │   IP: 172.21.0.4 │
                                               └─────────────────┘
```

## 🔄 Data Flow

```
1. Generate SSH Keys
   ↓
2. Create Dockerfile
   ↓
3. Build Docker Image
   ↓
4. Create Network
   ↓
5. Launch N Containers
   ↓
6. Setup SSH in Containers
   ↓
7. Exchange Host Keys
   ↓
8. Test Host → Container
   ↓
9. Test Container ↔ Container
   ↓
10. Generate Summary
```

## 📊 Connection Matrix (N=3)

| From/To         | Container 1 | Container 2 | Container 3 | Host |
| --------------- | ----------- | ----------- | ----------- | ---- |
| **Container 1** | -           | ✅          | ✅          | ✅   |
| **Container 2** | ✅          | -           | ✅          | ✅   |
| **Container 3** | ✅          | ✅          | -           | ✅   |
| **Host**        | ✅          | ✅          | ✅          | -    |

**Total Connections Tested: 9** (3 host-to-container + 6 container-to-container)

## 🛠️ Key Technologies

### Docker Components

- **Dockerfile**: Blueprint for container creation
- **Docker Image**: Reusable template
- **Docker Containers**: Running instances
- **Docker Network**: Virtual network for communication

### SSH Components

- **RSA Key Pair**: Public/private keys for authentication
- **Authorized Keys**: Public keys stored in containers
- **Known Hosts**: Host fingerprints for verification
- **Parallel SSH**: Tool for simultaneous connections

### Networking

- **Bridge Network**: Isolated network for containers
- **IP Assignment**: Automatic IP allocation
- **Port 22**: Standard SSH port

## 📁 File Structure

```
/N02-Linux Cluster/
├── N02.txt                 # Main script
├── Dockerfile             # Generated container blueprint
├── known_hosts           # SSH host fingerprints
├── keydir/               # SSH keys directory
│   ├── my_key           # Private key
│   └── my_key.pub       # Public key
└── docs/                 # Documentation
    ├── README.md         # Comprehensive guide
    ├── STEP_BY_STEP_GUIDE.md  # Tutorial
    ├── TROUBLESHOOTING.md     # Problem solving
    ├── FAQ.md            # Common questions
    └── OVERVIEW.md       # This file
```

## 🎯 Success Criteria

✅ **All 10 steps complete without errors**
✅ **All host-to-container connections successful**
✅ **All container-to-container connections successful**
✅ **No "FAILED" messages in output**
✅ **Summary shows expected connection counts**

## 🚀 Quick Start

```bash
# Navigate to project
cd "N02-Linux Cluster"

# Make executable
chmod +x N02.txt

# Run with 3 containers
./N02.txt 3

# Expected runtime: 10-30 seconds
# Expected result: 9 successful connections
```

## 📈 Scaling

| N   | Containers | Connections | Est. Time |
| --- | ---------- | ----------- | --------- |
| 2   | 2          | 4           | 5-10s     |
| 3   | 3          | 9           | 10-20s    |
| 5   | 5          | 25          | 20-40s    |
| 10  | 10         | 100         | 1-2 min   |

**Formula:** For N containers, total connections = N + N×(N-1) = N²

## 🔐 Security Features

- **Passwordless Authentication**: SSH keys eliminate password prompts
- **Host Key Verification**: Prevents man-in-the-middle attacks
- **Isolated Network**: Containers only accessible via SSH
- **No Password Authentication**: Disabled in containers
- **Root Access**: Controlled SSH key-based access only

## 🎓 Learning Outcomes

After completing this project, you'll understand:

- Containerization with Docker
- Network configuration
- SSH key management
- Parallel processing
- Bash scripting
- System administration basics
- Cloud computing concepts

---

**Ready to start? Follow the [Step-by-Step Guide](STEP_BY_STEP_GUIDE.md)!** 🚀
