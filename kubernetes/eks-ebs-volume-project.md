#eks-ebs-volume-project
```
ec2-user@ip-172-31-1-141 ~]$ history
    1  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	sudo apt install unzip -y
    2  sudo unzip awscliv2.zip
    3  sudo ./aws/install
    4  curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    5  sudo mv /tmp/eksctl /usr/local/bin
    6  eksctl version
    7  sudo curl --silent --location -o /usr/local/bin/kubectl   https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl
    8  sudo chmod +x /usr/local/bin/kubectl
    9  kubectl version --short --client
   10  curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/aws-iam-authenticator
   11  chmod +x ./aws-iam-authenticator
   12  sudo mv ./aws-iam-authenticator /usr/local/bin
   13  aws-iam-authenticator help
   14  aws configure
   15  eksctl create cluster tom --region us-east-1 --nodegroup-name jerry --node-type t3.medium --vpc-public-subnets subnet-068629f8064ccbf5c,subnet-010a917b3af095596 --vpc-private-subnets subnet-06657758370d91032,subnet-000001a7318867bc2
   16  aws configure
   17  export CLUSTER_NAME=tom
   18  oidc_id=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
   19  eksctl utils associate-iam-oidc-provider --cluster $CLUSTER_NAME --approve
   21  oidc_id=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
   
   
   create iam role for AmazonEKS_EBS_CSI_DriverRole1
   
   
   add trunt relationship in role
   "oidc.eks.us-east-1.amazonaws.com/id/080F2318C3627FBDF8EAC85874B8DE56:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
   
   
   22  aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4
   24  aws eks describe-addon-versions --addon-name aws-ebs-csi-driver
   25  eksctl create addon --name aws-ebs-csi-driver --cluster $CLUSTER_NAME --service-account-role-arn arn:aws:iam::055290120866:role/AmazonEKS_EBS_CSI_DriverRole1 --force
   
   eksctl create addon --name aws-ebs-csi-driver --cluster $CLUSTER_NAME --service-account-role-arn arn:aws:iam::236895416207:role/AmazonEKS_EBS_CSI_DriverRole --forceeksctl create addon --name aws-ebs-csi-driver --cluster $CLUSTER_NAME --service-account-role-arn arn:aws:iam::236895416207:role/AmazonEKS_EBS_CSI_DriverRole --force
   26  eksctl create addon --name aws-ebs-csi-driver --cluster $CLUSTER_NAME --service-account-role-arn arn:aws:iam::236895416207:role/AmazonEKS_EBS_CSI_DriverRole --force
   27  eksctl get addon --name aws-ebs-csi-driver --cluster $CLUSTER_NAME
   28  eksctl create addon --name aws-ebs-csi-driver --cluster $CLUSTER_NAME --service-account-role-arn arn:aws:iam::236895416207:role/AmazonEKS_EBS_CSI_DriverRole --force
   29  echo $CLUSTER_NAME
   30  export CLUSTER_NAME=EKS
   31  aws configure
   32  echo $CLUSTER_NAME
   33  eksctl create addon --name aws-ebs-csi-driver --cluster $CLUSTER_NAME --service-account-role-arn arn:aws:iam::236895416207:role/AmazonEKS_EBS_CSI_DriverRole --force
   34  eksctl get addon --name aws-ebs-csi-driver --cluster $CLUSTER_NAME
   35  git clone https://github.com/kubernetes-sigs/aws-ebs-csi-driver.git
   36  sudo yum git install
   37  vim Storageclass.yaml
   38  vim claim.yaml
   39  vim pod.yaml
   40  cat Storageclass.yaml 
   41  cat claim.yaml 
   42  cat pod.yaml 
   43  sudo kubectl apply -f Storageclass.yaml 
   44  kubectl apply -f Storageclass.yaml 
   45  kubectl apply -f claim.yaml 
   46  kubectl apply -f pod.yaml 
   47  kubectl get pods
   48  kubectl get pvc
   49  kubectl get pods
   50  kubectl get pvc -a
   51  kubectl get pvc -A
   52  history
[ec2-user@ip-172-31-1-141 ~]$ 




ubuntu@ip-172-31-5-88:~/sam$ history
    1  clear
    2  kubectl
    3  clear
    4  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    5  sudo unzip awscliv2.zip
    6  sudo apt install unzip -y
    7  sudo unzip awscliv2.zip && sudo ./aws/install
    8  curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    9  sudo mv /tmp/eksctl /usr/local/bin
   10  eksctl version
   11  sudo curl --silent --location -o /usr/local/bin/kubectl   https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl
   12  sudo chmod +x /usr/local/bin/kubectl
   13  kubectl version --short --client
   14  curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/aws-iam-authenticator
   15  chmod +x ./aws-iam-authenticator
   16  sudo mv ./aws-iam-authenticator /usr/local/bin
   17  aws-iam-authenticator help
   18  aws configure
   19  eksctl create cluster tom --region us-east-1 --nodegroup-name jerry --node-type t3.medium --vpc-public-subnets subnet-068629f8064ccbf5c,subnet-010a917b3af095596 --vpc-private-subnets subnet-06657758370d91032,subnet-000001a7318867bc2
   20  kubectl get nodes
   21  export CLUSTER_NAME=tom
   22  oidc_id=$(aws EKS describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
   23  oidc_id=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
   24  echo $oidc_id
   25  eksctl utils associate-iam-oidc-provider --cluster $CLUSTER_NAME --approve
   26  aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4
   27  eksctl create addon --name aws-ebs-csi-driver --cluster $CLUSTER_NAME --service-account-role-arn arnarn:aws:iam::236895416207:role/AmazonEKS_EBS_CSI_DriverRole1 --force
   28  echo $CLUSTER_NAME
   29  aws configure
   30  eksctl create addon --name aws-ebs-csi-driver --cluster $CLUSTER_NAME --service-account-role-arn arn:aws:iam::236895416207:role/AmazonEKS_EBS_CSI_DriverRole1 --force
   31  eksctl get addon --name aws-ebs-csi-driver --cluster $CLUSTER_NAME
   32  nano sc.yaml
   33  mkdir sam
   34  mv sc.yaml sam/
   35  cd sam/
   36  ls
   37  nano claim.yaml
   38  nano pod.yaml
   39  kubectl apply -f sc.yaml
   40  kubectl apply -f claim.yaml
   41  kubectl apply -f pod.yaml
   42  kubectl get pvc _A
   43  kubectl get pvc -A
   44  history
```
