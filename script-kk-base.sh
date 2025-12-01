#!/bin/bash

echo "Preparing kk-base before cloning..."
echo "-------------------------------------------"

########################################
# 1. System update
########################################
echo "Updating system..."
sudo apt update -y && sudo apt upgrade -y

########################################
# 2. Install dependencies
########################################
echo "Installing dependencies..."
sudo apt install -y python3 python3-pip openssh-server sshpass net-tools

########################################
# 3. Install Ansible
########################################
echo "Installing Ansible..."
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

########################################
# 3bis. Clipboard support (VirtualBox)
########################################
echo "Installing clipboard support (VirtualBox Guest Utils)..."
sudo apt install -y virtualbox-guest-utils

########################################
# 4. SSH configuration
########################################
echo "Configuring SSH service..."
sudo systemctl enable ssh
sudo systemctl restart ssh

########################################
# 5. Forced configuration of ansible user
########################################
echo "Configuring ansible user (forced mode)..."

# Create user if missing
if ! id ansible &>/dev/null; then
    sudo useradd -m ansible -s /bin/bash
fi

# Force correct shell
sudo usermod -s /bin/bash ansible

# Force password
echo "ansible:ansible" | sudo chpasswd

# Ensure correct home folder
sudo mkdir -p /home/ansible
sudo chown -R ansible:ansible /home/ansible

# Force sudo rights
echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible >/dev/null
sudo chmod 440 /etc/sudoers.d/ansible

########################################
# 6. SSH key generation for ansible
########################################
echo "Generating SSH keys..."
sudo mkdir -p /home/ansible/.ssh
sudo -u ansible ssh-keygen -t rsa -b 4096 -f /home/ansible/.ssh/id_rsa -N ""

# Set public key as authorized key
sudo cat /home/ansible/.ssh/id_rsa.pub | sudo tee /home/ansible/.ssh/authorized_keys >/dev/null
sudo chown -R ansible:ansible /home/ansible/.ssh
sudo chmod 700 /home/ansible/.ssh
sudo chmod 600 /home/ansible/.ssh/authorized_keys

########################################
# 7. Netplan configuration
########################################
echo "Configuring netplan..."

# Detect interface name
INTERFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -E "en|eth" | head -n 1)

cat <<EOF | sudo tee /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    $INTERFACE:
      dhcp4: no
      addresses: [192.168.1.200/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]
EOF

echo "Applying netplan..."
sudo netplan apply

########################################
# 8. Cleanup before cloning
########################################
echo "Cleaning machine unique identifiers..."

# Remove SSH host keys
sudo rm -f /etc/ssh/ssh_host_*

# Remove DHCP leases
sudo rm -f /var/lib/dhcp/dhclient.*

echo "-------------------------------------------"
echo "kk-base is now fully ready for cloning."
echo "Ansible OK"
echo "SSH OK"
echo "User ansible OK"
echo "SSH keys OK"
echo "Netplan OK"
echo "-------------------------------------------"
