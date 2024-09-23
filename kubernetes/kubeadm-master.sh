#!/bin/bash

#-----Set hostname-------

sudo hostnamectl set-hostname "k8smaster"
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

sudo apt update && sudo apt install -y containerd.io docker-ce

#-----Configure containerd so that it starts using systemd as cgroup.---

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

#------Restart and enable containerd service----

sudo systemctl restart containerd && sudo systemctl enable containerd

#------Add apt repository for Kubernetes-------

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

#----- Install Kubernetes components Kubectl, kubeadm & kubelet-----

sudo apt update && sudo apt install -y kubelet kubeadm kubectl && sudo apt-mark hold kubelet kubeadm kubectl

#----- Initialize Kubernetes cluster with Kubeadm command---------

sudo kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#------- Install Flannel Pod Network Add-on-------
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

#-----for calico if you want you can change------
#kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml ---
