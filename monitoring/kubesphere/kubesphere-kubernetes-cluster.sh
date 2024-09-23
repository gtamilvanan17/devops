sudo apt update
sudo apt install curl socat conntrack ebtables ipset -y
curl -sfL https://get-kk.kubesphere.io | VERSION=v3.0.2 sh -
chmod +x kk
./kk create cluster --with-kubernetes v1.24.2 --with-kubesphere v3.3.1 --container-manager containerd
