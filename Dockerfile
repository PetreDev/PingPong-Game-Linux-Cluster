FROM ubuntu:22.04

# Prevent interactive prompts during apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Install OpenSSH server, sudo, and parallel-ssh
RUN apt-get update && \
    apt-get install -y openssh-server sudo pssh && \
    mkdir -p /var/run/sshd && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user with home directory and SSH folder
RUN useradd -m -s /bin/bash student && \
    mkdir -p /home/student/.ssh && \
    chown -R student:student /home/student

# Setup SSH directories (relying on Ubuntu 22.04 default SSH configuration)
RUN mkdir -p /root/.ssh

# Generate SSH host keys
RUN ssh-keygen -A

# Expose port 22 for SSH
EXPOSE 22

# Start the SSH daemon in foreground when container runs
CMD ["/usr/sbin/sshd", "-D"]
