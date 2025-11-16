# Frequently Asked Questions (FAQ)

## 🤔 Basic Questions

### Q: What is this project?

**A:** This creates a cluster of connected Linux computers using Docker containers. Instead of buying multiple physical computers, we use lightweight virtual containers that can securely communicate with each other.

### Q: Why Docker instead of VirtualBox?

**A:** Docker containers are:

- **Faster** to start (seconds vs minutes)
- **Lighter** on system resources
- **Easier** to manage programmatically
- **Better** for automation and cloud computing

### Q: What's SSH?

**A:** SSH (Secure Shell) is a protocol for securely connecting to remote computers. It's like a secure telephone that encrypts all communication.

### Q: What's the difference between `hostname -i` and `hostname -I`?

**A:** Both show IP addresses, but:

- `hostname -i`: Shows the primary IP address
- `hostname -I`: Shows all IP addresses (including multiple network interfaces)

We use `-I` to see all addresses.

---

## 🚀 Running the Script

### Q: How do I run it?

**A:**

```bash
# Make executable (first time only)
chmod +x N02.txt

# Run with 3 containers (default)
./N02.txt

# Or specify number of containers
./N02.txt 5
```

### Q: What does the number mean?

**A:** The number (N) specifies how many containers to create. For N=3, you get 3 containers and test 3×3=9 total connections.

### Q: How long does it take?

**A:** Usually 10-30 seconds for 3 containers. More containers take longer due to more connection tests.

### Q: Can I run it multiple times?

**A:** Yes, but clean up first:

```bash
# Cleanup from previous run
docker stop $(docker ps -q --filter 'name=ssh-container-')
docker rm $(docker ps -aq --filter 'name=ssh-container-')
docker network rm ssh-cluster-net-alt
```

---

## 🔧 Technical Questions

### Q: What IP addresses are used?

**A:** The script tries `172.20.0.0/16` first, but uses `172.21.0.0/16` if there's a conflict. Containers get IPs like:

- Container 1: 172.21.0.2
- Container 2: 172.21.0.3
- Container 3: 172.21.0.4

### Q: What's parallel-ssh?

**A:** A tool that runs the same command on multiple computers simultaneously. Instead of connecting one-by-one, it connects to all targets at once.

### Q: Why use SSH keys instead of passwords?

**A:** Keys are:

- More secure (can't be guessed)
- Allow automation (no password prompts)
- Work for multiple computers with one key

### Q: What's a "known_hosts" file?

**A:** A security file that remembers the unique fingerprint of each computer you've connected to. Prevents man-in-the-middle attacks.

---

## 🔍 Understanding Output

### Q: What does "Host -> 172.21.0.2: 172.21.0.2" mean?

**A:** Your computer (Host) successfully connected to container at IP 172.21.0.2, and the container reported its IP address as 172.21.0.2.

### Q: What does "[SUCCESS]" mean?

**A:** The connection attempt worked. The parallel-ssh tool successfully connected to that container.

### Q: Why do I see duplicate IP addresses?

**A:** The first IP (after [SUCCESS]) is the target address, the second line is the output of the `hostname -I` command run on that container.

---

## 🐛 Problems & Solutions

### Q: Script says "Permission denied"

**A:** Run `chmod +x N02.txt` to make the script executable.

### Q: Docker command not found

**A:** Install Docker:

```bash
sudo apt update && sudo apt install docker.io
sudo systemctl start docker
```

### Q: Connections fail with "FAILED"

**A:** Common causes:

- Containers not fully started (wait longer)
- SSH service not running in containers
- Network configuration issues

### Q: Script hangs or is very slow

**A:** Check system resources:

```bash
free -h    # Memory
df -h      # Disk space
top        # CPU usage
```

Try with fewer containers: `./N02.txt 2`

---

## 🧹 Cleanup Questions

### Q: How do I clean up after running?

**A:**

```bash
# Stop containers
docker stop $(docker ps -q --filter 'name=ssh-container-')

# Remove containers
docker rm $(docker ps -aq --filter 'name=ssh-container-')

# Remove network
docker network rm ssh-cluster-net-alt

# Remove image (optional)
docker image rm linux-ssh-cluster
```

### Q: What files are created?

**A:**

- `Dockerfile` - Blueprint for containers
- `known_hosts` - SSH fingerprints
- `keydir/` - SSH keys (my_key, my_key.pub)

### Q: Can I delete the generated files?

**A:** Yes, they're recreated each time you run the script.

---

## 🎓 Learning Questions

### Q: What concepts does this teach?

**A:**

- Container orchestration (Docker)
- Network configuration
- SSH key management
- Parallel processing
- Bash scripting
- System administration

### Q: Is this similar to cloud computing?

**A:** Yes! Companies like AWS, Google Cloud, and Azure use similar techniques to manage thousands of servers in clusters.

### Q: What's the difference between this and real cloud clusters?

**A:**

- **Scale**: Real clusters have thousands of servers
- **Hardware**: Real servers have dedicated CPUs, memory, storage
- **Networking**: Real clusters use complex network topologies
- **Management**: Real clusters use tools like Kubernetes

But the core concepts (containers, networking, SSH) are the same!

### Q: What can I do after this project?

**A:** Learn:

- Kubernetes for container orchestration
- Ansible for configuration management
- Terraform for infrastructure as code
- AWS/Azure/GCP cloud platforms

---

## 📚 Resources

### Documentation

- [Docker Official Docs](https://docs.docker.com/)
- [SSH Key Guide](https://www.ssh.com/academy/ssh-keys)
- [Bash Scripting](https://tldp.org/LDP/abs/html/)

### Related Projects

- Docker Compose for multi-container apps
- Kubernetes for container orchestration
- Ansible for server automation

---

**Still have questions? Check the troubleshooting guide or ask your instructor!** 😊
