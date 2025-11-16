# Troubleshooting Guide - Common Issues & Solutions

## 🚨 "Permission denied" when running script

### Error:

```bash
bash: ./N02.txt: Permission denied
```

### Solution:

```bash
# Make the script executable
chmod +x N02.txt

# Then run it
./N02.txt 3
```

**Why this happens:** Linux needs to know the file can be executed as a program.

---

## 🚨 Docker not found or not running

### Error:

```bash
docker: command not found
# OR
docker: Got permission denied while trying to connect to the Docker daemon socket
```

### Solutions:

#### Check if Docker is installed:

```bash
docker --version
```

#### Install Docker (Ubuntu/Debian):

```bash
sudo apt update
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
```

#### Start Docker service:

```bash
sudo systemctl start docker
```

#### Add user to docker group (optional):

```bash
sudo usermod -aG docker $USER
# Logout and login again for changes to take effect
```

---

## 🚨 Script runs but containers fail to start

### Check Docker is running:

```bash
sudo systemctl status docker
```

### Check available disk space:

```bash
df -h
```

### Clean up old containers/images:

```bash
# Remove stopped containers
docker container prune -f

# Remove unused images
docker image prune -f

# Remove unused networks
docker network prune -f
```

---

## 🚨 SSH connection failures

### Error in output:

```
Host -> 172.21.0.2: FAILED
```

### Possible causes & solutions:

#### 1. Containers not fully started

**Wait longer:** The script includes `sleep 5` but sometimes needs more time.

#### 2. SSH keys not copied

**Check manually:**

```bash
# List container files
docker exec ssh-container-1 ls -la /root/.ssh/

# Check key permissions
docker exec ssh-container-1 ls -la /root/.ssh/authorized_keys
```

#### 3. Firewall blocking SSH

**Check if SSH port 22 is accessible:**

```bash
# From host to container
ssh -v -i keydir/my_key root@172.21.0.2
```

---

## 🚨 Network conflicts

### Script shows:

```
Subnet conflict detected, trying alternative subnet...
```

### This is normal! The script handles this automatically.

### If you want to avoid conflicts:

```bash
# Remove existing networks
docker network ls
docker network rm <network-name>
```

---

## 🚨 "parallel-ssh: command not found"

### This means parallel-ssh isn't installed in containers.

### Check the Dockerfile was created correctly:

```bash
cat Dockerfile
```

Should include:

```dockerfile
RUN apt-get install -y parallel-ssh
```

### Rebuild if needed:

```bash
# Clean up
docker stop $(docker ps -q --filter 'name=ssh-container-')
docker rm $(docker ps -aq --filter 'name=ssh-container-')
docker network rm ssh-cluster-net-alt
docker image rm linux-ssh-cluster

# Remove files
rm -f Dockerfile known_hosts
rm -rf keydir/

# Run script again
./N02.txt 3
```

---

## 🚨 Script hangs or takes too long

### Check system resources:

```bash
# CPU usage
top

# Memory usage
free -h

# Disk space
df -h
```

### Stop with Ctrl+C and try fewer containers:

```bash
./N02.txt 2  # Instead of 3
```

---

## 🚨 "bind: address already in use"

### Error:

```
docker: Error response from daemon: driver failed programming external connectivity on endpoint ssh-container-1: bind: address already in use
```

### Solution:

```bash
# Find what's using the port
sudo netstat -tulpn | grep :22

# Kill the process (be careful!)
sudo kill <PID>

# Or use a different port (advanced)
```

---

## 🚨 Cannot connect to containers after script finishes

### Containers might have stopped. Check status:

```bash
docker ps -a --filter 'name=ssh-container-'
```

### Restart containers:

```bash
docker start ssh-container-1 ssh-container-2 ssh-container-3
```

### Or run script again:

```bash
./N02.txt 3
```

---

## 🔍 Debugging Commands

### Check container logs:

```bash
docker logs ssh-container-1
```

### Enter container manually:

```bash
docker exec -it ssh-container-1 bash
```

### Check network:

```bash
docker network ls
docker network inspect ssh-cluster-net-alt
```

### Check SSH service inside container:

```bash
docker exec ssh-container-1 systemctl status ssh
```

---

## 📞 Getting Help

If you're still stuck:

1. **Check the README.md** - Comprehensive explanations
2. **Read the script comments** - Each step is documented
3. **Google the error message** - Include "docker" or "ssh" in search
4. **Check Docker documentation** - https://docs.docker.com/

---

## 🆘 Emergency Cleanup

If everything goes wrong:

```bash
# Stop ALL containers
docker stop $(docker ps -aq)

# Remove ALL containers
docker rm $(docker ps -aq)

# Remove ALL networks
docker network rm $(docker network ls -q)

# Remove ALL images (careful!)
docker rmi $(docker images -q)

# Remove generated files
rm -f Dockerfile known_hosts
rm -rf keydir/
```

Then start fresh with `./N02.txt 3`

---

## ✅ Success Checklist

After running the script, verify:

- [ ] 3 containers created: `docker ps`
- [ ] Network created: `docker network ls`
- [ ] Can connect manually: `ssh -i keydir/my_key root@172.21.0.2`
- [ ] All connections tested in output
- [ ] No "FAILED" messages in final output

If all checks pass: **🎉 Congratulations! Your cluster is working!**
