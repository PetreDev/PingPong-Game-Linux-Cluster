# Step-by-Step Guide: Running Your First Linux Cluster

## 🎯 Goal

By the end of this guide, you'll have created 3 connected Linux computers that can talk to each other securely.

---

## Step 1: Check Your Environment ✅

### Open Terminal

```
# On Linux/Mac: Press Ctrl+Alt+T or search for "Terminal"
# On Windows: Use WSL or Git Bash
```

### Navigate to Project Folder

```bash
cd "/home/jokac/Desktop/Personal/FERI/Cloud Computing/N02-Linux Cluster"
```

### Check Docker is Running

```bash
docker --version
# Should show: Docker version 24.x.x or similar
```

---

## Step 2: Make Script Executable 🛠️

```bash
chmod +x N02.txt
```

**What this does:** Tells Linux this file can be run as a program.

---

## Step 3: Run the Script 🚀

```bash
./N02.txt 3
```

**What happens next:**

- You'll see "Creating 3 container instances..."
- The script will work through 10 steps automatically
- This takes about 10-30 seconds
- You'll see lots of output showing progress

---

## Step 4: Watch the Magic Happen ✨

The script will show you:

### Step 1-3: Preparation

```
Step 1: Generating RSA keys for passwordless SSH.
Step 2: Creating Dockerfile.
Step 3: Building Docker image.
```

### Step 4-5: Network Setup

```
Step 4: Creating Docker network.
Step 5: Creating 3 containers with unique IP addresses.
```

### Step 6-7: Security Setup

```
Step 6: Setting up SSH keys in all containers.
Step 7: Scanning SSH host keys.
```

### Step 8-9: Testing (The Exciting Part!)

```
Step 8: Testing connections from host (computer 0) to containers.
Step 9: Testing all container-to-container connections using parallel-ssh.
```

---

## Step 5: Understanding the Results 📊

### Host to Container Connections

```
Host -> 172.21.0.2: 172.21.0.2
Host -> 172.21.0.3: 172.21.0.3
Host -> 172.21.0.4: 172.21.0.4
```

✅ **Your computer successfully connected to all 3 containers!**

### Container to Container Connections

```
Container 172.21.0.2 connecting to all others:
  [1] 23:14:04 [SUCCESS] 172.21.0.3
  172.21.0.3
  [2] 23:14:04 [SUCCESS] 172.21.0.4
  172.21.0.4
```

✅ **Container 1 successfully connected to containers 2 and 3!**

### Final Summary

```
Created 3 containers:
  Container 1: ssh-container-1 (IP: 172.21.0.2, ID: abc123...)
  Container 2: ssh-container-2 (IP: 172.21.0.3, ID: def456...)
  Container 3: ssh-container-3 (IP: 172.21.0.4, ID: ghi789...)

Total connections tested:
  Host -> Containers: 3
  Container -> Container: 6
  Total: 9
```

✅ **All 9 connections worked! You have a fully functional cluster!**

---

## Step 6: Manual Testing (Optional) 🔍

### Connect to a Container Manually

```bash
ssh -i keydir/my_key root@172.21.0.2
```

### Run Commands Inside Container

```bash
hostname -I  # Shows IP addresses
whoami       # Shows current user (root)
ls -la       # Lists files
exit         # Disconnect
```

---

## Step 7: Cleanup 🧹

When you're done experimenting:

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

---

## 🎉 Congratulations!

You've successfully:

- ✅ Created 3 Linux containers
- ✅ Set up secure SSH communication
- ✅ Configured a private network
- ✅ Tested all possible connections
- ✅ Built a working Linux cluster!

---

## 🔄 Try Different Numbers

```bash
# Create 2 containers
./N02.txt 2

# Create 5 containers
./N02.txt 5

# Create 10 containers (takes longer)
./N02.txt 10
```

**Note:** More containers = more connections to test. For N containers, you'll test N×N total connections!

---

## 📝 What to Submit

Your professor asked for:

1. ✅ **Script code** - The N02.txt file
2. ✅ **Running output** - The commented section in N02.txt shows actual execution
3. ✅ **Step descriptions** - Comments throughout the script explain each step

**Your N02.txt file is ready to submit!** 🚀
