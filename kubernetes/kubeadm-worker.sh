#!/bin/bash

#-----Set hostname-------

#sudo hostnamectl set-hostname "k8sworker"
#exec bash

#-----Disable swap & add kernel settings-----

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

#-----Load the following kernel modules on all the nodes------

sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

sudo modprobe overlay && sudo modprobe br_netfilter

#----Set the following Kernel parameters for Kubernetes, run beneath tee command----

sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

#-------Reload the above changes, run-----
sudo sysctl --system

#-----Install containerd run time-------

sudo apt install -y curl gnupg software-properties-common apt-transport-https ca-certificates

#-----Enable docker repository----

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
echo | sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

#----Run following apt command to install containerd-----

sudo apt update && sudo apt install -y containerd.io

#-----Configure containerd so that it starts using systemd as cgroup.---

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

#------Restart and enable containerd service----

sudo systemctl restart containerd && sudo systemctl enable containerd

#------Add apt repository for Kubernetes-------

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/kubernetes-xenial.gpg

echo | sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

#----- Install Kubernetes components Kubectl, kubeadm & kubelet-----

sudo apt update && sudo apt install -y kubelet kubeadm kubectl && sudo apt-mark hold kubelet kubeadm kubectl
