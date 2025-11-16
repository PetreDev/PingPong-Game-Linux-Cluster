# N02 Linux Cluster SSH Environment Setup - Beginner's Guide

## What is this project?

This project creates a **Linux cluster** - a group of connected Linux computers that can talk to each other using SSH (Secure Shell). Instead of using real physical computers, we use **Docker containers** (like lightweight virtual machines).

## 🏗️ What does the script do?

The `N02.txt` script automatically sets up N identical Linux environments that can communicate with each other. Here's what happens when you run it:

### Step 1: Generate SSH Keys 🔑

- Creates a pair of special files (public key and private key)
- These act like a digital key and lock for secure connections
- Think of it like a master key that works for all your "houses" (containers)

### Step 2: Create a Docker Blueprint 🏭

- Makes a `Dockerfile` that describes how to build each Linux container
- Includes Ubuntu Linux, SSH server, and tools for parallel connections

### Step 3: Build the Docker Image 🛠️

- Takes the blueprint and creates a reusable template
- Like baking a cake from a recipe - you can make multiple identical cakes

### Step 4: Create a Private Network 🌐

- Sets up a virtual network where containers can talk to each other
- Gives each container its own unique IP address (like house numbers)

### Step 5: Launch N Containers 🚀

- Creates N copies of the Linux environment
- Each gets a unique name and IP address
- Default is 3 containers, but you can specify any number

### Step 6: Setup SSH Keys in All Containers 🔐

- Copies the master SSH keys to every container
- Sets up passwordless login between all containers

### Step 7: Scan and Trust SSH Fingerprints 🤝

- Collects unique identifiers (fingerprints) from each container
- Creates a "phonebook" so containers know each other

### Step 8: Test Host → Container Connections 🖥️→💻

- From your computer, connects to each container
- Runs `hostname -I` command to show the container's IP address

### Step 9: Test All Container-to-Container Connections 💻↔️💻

- Each container connects to all other containers
- Uses `parallel-ssh` to test multiple connections at once
- Runs `hostname -I` on each target container

### Step 10: Summary 📊

- Shows how many containers were created
- Counts total connections tested

## 🚀 How to Run It

### Prerequisites

- Docker must be installed and running
- Basic command line knowledge

### Basic Usage

```bash
# Create 3 containers (default)
./N02.txt

# Create 5 containers
./N02.txt 5

# Create 10 containers
./N02.txt 10
```

### What You'll See

The script will show progress through 10 steps, then display connection test results like:

```
Host -> 172.21.0.2: 172.21.0.2
Host -> 172.21.0.3: 172.21.0.3
Host -> 172.21.0.4: 172.21.0.4

Container 172.21.0.2 connecting to all others:
  [1] 23:14:04 [SUCCESS] 172.21.0.3
  172.21.0.3
  [2] 23:14:04 [SUCCESS] 172.21.0.4
  172.21.0.4
```

## 🌐 Docker Networking Explained (Beginner Friendly)

> 📖 **Want to learn more?** Check out our [complete Docker networking guide](DOCKER_NETWORKING.md) for advanced concepts and troubleshooting.

### What is Docker Networking?

Imagine you have several houses (containers) in a neighborhood (network). Docker networking is like the roads and addresses that connect these houses, allowing them to communicate with each other.

### Types of Docker Networks

1. **Bridge Network** (What we use) - Like a private neighborhood

   - Isolated from other networks
   - Containers get their own IP addresses
   - Perfect for containers that need to talk to each other

2. **Host Network** - Containers share the host's network directly

3. **None Network** - No networking (containers are isolated)

### How Our Script Uses Docker Networking

#### Step 4: Creating the Network

```bash
docker network create --subnet=172.20.0.0/16 ssh-cluster-net
```

**What this means:**

- `--subnet=172.20.0.0/16`: Creates a private IP address range
  - `172.20.0.0/16` = IP addresses from 172.20.0.1 to 172.20.255.254
  - `/16` means 65,536 possible addresses
- `ssh-cluster-net`: Name of our private neighborhood

#### Step 5: Connecting Containers to the Network

```bash
docker run -d --name ssh-container-1 --network ssh-cluster-net --ip 172.20.0.2 linux-ssh-cluster
```

**What this means:**

- `--network ssh-cluster-net`: Connects container to our private network
- `--ip 172.20.0.2`: Assigns specific address (like a house number)
- Container gets its own unique IP address in the network

### Network Communication Flow

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Host Computer │     │  Docker Bridge  │     │   Containers    │
│   (Outside)     │─────│   Network       │─────│   (Inside)      │
│                 │     │                 │     │                 │
│ • IP: 192.168.x │     │ • Gateway:      │     │ • ssh-container-1│
│ • Can access    │     │   172.20.0.1   │     │   IP: 172.20.0.2 │
│   containers    │     │ • Subnet:       │     │                 │
└─────────────────┘     │   172.20.0.0/16│     │ • ssh-container-2│
                        └─────────────────┘     │   IP: 172.20.0.3 │
                                                │                 │
                                                │ • ssh-container-3│
                                                │   IP: 172.20.0.4 │
                                                └─────────────────┘
```

### Why IP Addresses Matter

1. **Unique Identity**: Each container has its own address
2. **Routing**: Docker knows how to deliver traffic to the right container
3. **SSH Access**: We can connect using `ssh root@172.20.0.2`

### Real-World Analogy

Think of it like this:

- **Host Computer** = Your house with internet
- **Docker Bridge Network** = A private gated community
- **Subnet** = The community's address range (172.20.x.x)
- **Container IPs** = Individual house numbers (172.20.0.2, 172.20.0.3, etc.)
- **SSH Connections** = Phone calls between houses

### Why This is Powerful

1. **Isolation**: Containers can't interfere with your host network
2. **Consistency**: Same setup works on any computer with Docker
3. **Security**: Private network protects containers from outside access
4. **Flexibility**: Easy to add/remove containers without affecting others

### Troubleshooting Network Issues

#### Check Network Exists

```bash
docker network ls
# Should show: ssh-cluster-net-alt
```

#### Check Container IPs

```bash
docker inspect ssh-container-1 | grep IPAddress
# Should show: "IPAddress": "172.21.0.2"
```

#### Test Connectivity

```bash
# From one container to another
docker exec ssh-container-1 ping 172.21.0.2
```

#### View Network Details

```bash
docker network inspect ssh-cluster-net-alt
# Shows all connected containers and their IPs
```

## 🧹 Cleanup

After you're done, clean up with these commands:

```bash
# Stop all containers
docker stop $(docker ps -q --filter 'name=ssh-container-')

# Remove all containers
docker rm $(docker ps -aq --filter 'name=ssh-container-')

# Remove network
docker network rm ssh-cluster-net-alt

# Remove Docker image
docker image rm linux-ssh-cluster
```

## 🔧 Key Concepts Explained

### Docker Containers 🐳

- Lightweight virtual machines
- Share the host computer's kernel
- Faster than full virtual machines (like VirtualBox)
- Each container is isolated but can communicate via networks

### SSH (Secure Shell) 🔒

- Protocol for secure remote access to computers
- Uses encryption to protect data
- Can use passwords OR keys (we use keys for automation)

### IP Addresses 📍

- Unique identifiers for devices on a network
- Like street addresses for houses
- Format: `192.168.1.1` or `172.21.0.2`

### Parallel SSH 📡

- Tool to run the same command on multiple computers simultaneously
- Much faster than connecting one-by-one
- Essential for testing large clusters

## 📁 Project Structure

```
/home/jokac/Desktop/Personal/FERI/Cloud Computing/N02-Linux Cluster/
├── N02.txt              # Main script
├── Dockerfile          # Docker blueprint (created by script)
├── docs/               # Documentation
│   └── README.md       # This file
├── keydir/             # SSH keys
│   ├── my_key          # Private key
│   └── my_key.pub      # Public key
└── known_hosts         # SSH host fingerprints
```

## 🤔 Why Docker Instead of VirtualBox?

Your professor mentioned VirtualBox, but this project uses Docker because:

1. **Faster**: Containers start in seconds vs minutes for VMs
2. **Lighter**: Use less memory and CPU
3. **Easier**: No GUI needed, works on servers
4. **Same Result**: Still demonstrates SSH clustering concepts

## 🔍 Understanding the Output

### Connection Testing Results

```
Host -> 172.21.0.2: 172.21.0.2
```

- **Host**: Your computer
- **->**: Connecting to
- **172.21.0.2**: Container's IP address
- **: 172.21.0.2**: Command output (shows container's IP)

### Container-to-Container Results

```
Container 172.21.0.2 connecting to all others:
  [1] 23:14:04 [SUCCESS] 172.21.0.3
  172.21.0.3
```

- Container A connects to Container B
- `[1]`: First connection attempt
- `[SUCCESS]`: Connection worked
- `172.21.0.3`: Target container's IP
- Second line: Output of `hostname -I` command

## 🎯 What You Learn

This project teaches:

- **Network Configuration**: Setting up container networks
- **SSH Key Management**: Passwordless authentication
- **Parallel Processing**: Using tools like parallel-ssh
- **Docker**: Container orchestration
- **Bash Scripting**: Automating complex setups
- **System Administration**: Managing multiple Linux systems

## ❓ Troubleshooting

### "Permission denied" errors

- Make sure you're in the correct directory
- Ensure the script is executable: `chmod +x N02.txt`

### Docker not running

```bash
# Check Docker status
sudo systemctl status docker

# Start Docker if needed
sudo systemctl start docker
```

### Port conflicts

- The script handles network conflicts automatically
- May use `172.21.0.0/16` instead of `172.20.0.0/16`

### SSH connection failures

- Wait for containers to fully start (script includes delays)
- Check that SSH keys were copied correctly

## 📚 Further Reading

- [Docker Documentation](https://docs.docker.com/)
- [SSH Key Authentication](https://www.ssh.com/academy/ssh-keys)
- [Parallel SSH Documentation](https://parallel-ssh.readthedocs.io/)
- [Bash Scripting Guide](https://tldp.org/LDP/abs/html/)

---

**Congratulations!** You've just set up your first Linux cluster. This demonstrates real cloud computing concepts used by companies like Google, Amazon, and Microsoft to manage thousands of servers. 🚀
