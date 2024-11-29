#!/bin/bash

# Script for Automating Security Audits and Server Hardening on

# Display usage information
usage() {
  echo "Usage: $0 [--user|--permissions|--services|--firewall|--network|--updates|--ssh|--ipv6|--bootloader|--all]"
  echo "  --user       : User and group audits"
  echo "  --permissions: File and directory permissions"
  echo "  --services   : Service audits"
  echo "  --firewall   : Firewall and network security"
  echo "  --network    : IP and network configuration checks"
  echo "  --updates    : Security updates and patching"
  echo "  --ssh        : SSH configuration"
  echo "  --ipv6       : Disable IPv6"
  echo "  --bootloader : Secure the bootloader"
  echo "  --all        : Run all checks"
  exit 1
}

# To perform user and group audits
display_user_audit() {
  echo "User and Group Audits:"
  echo "List of Users:"
  cut -d: -f1 /etc/passwd
  echo "List of Groups:"
  cut -d: -f1 /etc/group
  echo "Users with UID 0 (root privileges):"
  awk -F: '$3 == 0 {print $1}' /etc/passwd
  echo "Users without passwords:"
  awk -F: '($2 == "" && $3 >= 1000) {print $1}' /etc/passwd
}

# To check file and directory permissions
display_permissions() {
  echo "File and Directory Permissions:"
  echo "World-writable files and directories:"
  find / -perm -002 -type f -o -type d 2>/dev/null
  echo ".ssh directories permissions:"
  find / -type d -name '.ssh' -exec ls -ld {} \; 2>/dev/null
  echo "Files with SUID or SGID bits set:"
  find / -perm /6000 -type f 2>/dev/null
}

# To audit running services
display_services() {
  echo "Service Audits:"
  echo "Running services:"
  systemctl list-units --type=service --state=running
  echo "Checking for unauthorized services:"
  # Custom logic to check for unauthorized services can be added here
}

# To check firewall and network security
display_firewall() {
  echo "Firewall and Network Security:"
  echo "Firewall status:"
  sudo ufw status verbose 2>/dev/null || sudo iptables -L
  echo "Open ports and associated services:"
  sudo netstat -tuln
  echo "IP forwarding status:"
  sysctl net.ipv4.ip_forward
}

# To perform IP and network configuration checks
display_network() {
  echo "IP and Network Configuration Checks:"
  echo "IP addresses:"
  ip addr show
  echo "Public vs. Private IPs:"
  for ip in $(hostname -I); do
    if [[ "$ip" =~ ^10\.|^172\.(1[6-9]|2[0-9]|3[0-1])|^192\.168\. ]]; then
      echo "$ip is a private IP"
    else
      echo "$ip is a public IP"
    fi
  done
}

# To check for security updates and patching
display_updates() {
  echo "Security Updates and Patching:"
  echo "Available security updates:"
  sudo apt list --upgradable 2>/dev/null | grep -i security || sudo yum check-update --security
}

# To configure SSH settings
configure_ssh() {
  echo "SSH Configuration:"
  echo "Disabling root password authentication:"
  sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
  echo "Enabling SSH key-based authentication:"
  # Ensure SSH keys are stored securely
  sudo systemctl restart sshd
}

# To disable IPv6 if not required
disable_ipv6() {
  echo "Disabling IPv6:"
  echo "Setting IPv6 to disabled in sysctl.conf:"
  echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
  echo "net.ipv6.conf.default.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
  echo "net.ipv6.conf.lo.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
  sudo sysctl -p
}

# To secure the bootloader
secure_bootloader() {
  echo "Securing the Bootloader:"
  echo "Setting GRUB password:"
  sudo grub-mkpasswd-pbkdf2  # Follow instructions to set a password and update GRUB config
}

# Main script logic to parse command-line arguments
if [ $# -eq 0 ]; then
  usage
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --user) display_user_audit ;;
    --permissions) display_permissions ;;
    --services) display_services ;;
    --firewall) display_firewall ;;
    --network) display_network ;;
    --updates) display_updates ;;
    --ssh) configure_ssh ;;
    --ipv6) disable_ipv6 ;;
    --bootloader) secure_bootloader ;;
    --all)
      display_user_audit
      display_permissions
      display_services
      display_firewall
      display_network
      display_updates
      configure_ssh
      disable_ipv6
      secure_bootloader
      ;;
    *) usage ;;
  esac
  shift
done
