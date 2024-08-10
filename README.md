## __SYSELF TASK__

Cretae a Github repository

`solomon-syself-devops`

Clone it into the local machine

`git clone <github-repository-link>`


cd into the repository directory 

`cd solomon-syself-devops`

## __Create and package a helm chart to deploy a simple backend__


Build and push and image  to an __image repository__ to be deployed using helm

Install Helm in your local machine. Click [here](https://helm.sh/docs/intro/install/).

Manually create a helm chart structure

`mkdir syself-helm-chart && cd syself-helm-chart`

`mkdir templates`

`touch Chart.yaml values.yaml`

`cd templates`

`touch deployment.yaml service.yaml ingress.yaml`

__Chart.yaml:__ Where the metadata of the helm chart is defined.

__values.yaml__: Defines the Helm chart default values.

__deployment.yaml:__ Kubernetes deployment resource.

__service.yaml:__ Defines the Kubernetes Service resource.

__Ingress.yaml:__ Ingress resources to manage external access to the services.

__Deploying the Database__

Use a stable database from Helm to integrate the database with the `syself-app` by adding it as a dependency in the `values.yaml` file. eg MYSQL

The database can also be deployed using managed services.

Deploying the database using helm chart will be preferred if we want full control of the management of the database and if resource to manage the deployment and configurations in the database is available.

Otherwise, the managed service is preferred for its high availability, optimized performance, less operational overhead and it is easily managed but more cost intensive when compared to managing the database using helm chart.

## __Setup the Kubernetes cluster__
Some of the major components of a kubernetes cluster include

- __Control plane (Master Nodes):__ - This schedules workloads and manages the state of the application and cluster. These tasks are carried out by the control plane using these components.
  - __Kube-apiserver:__ This is where client connect to the kubernetes API. It recieves requests and processes the request which is used to update the state of the cluster. 
  - __Kube-scheduler:__ This assigns newly created pods to pods based on the availability of resources and other factors in the pod.
  - __Kube-controller-manager:__ This manages the state of the kubernetes cluster which include replication, node management and general state management.
  - __etcd:__ Kubernetes is a stateless machine. The etcd is a distributed key value store that stores the state of the cluster which include the details of the nodes, pods and service.

__Worker Node:__ This handles the workload of the containers. The various components that work together to achieve this include:

  - __Kubelet:__ Communicates with the control plane to recieves instructions and report on the containers status in a pod.
  - __Kube-proxy:__ Handles network routing allowing communication between pods and services.

  - __Container Runtime:__ Runs and manages the containers on the node.

  - __Pod:__ The smallest unit in a kubernetes cluster that is deployable.

A production grade kubernetes cluster needs to be highly available, scalable and resilient.


We need to do a couple of things for the above set up:

-  Atleast 3 control planes to help with decision making and high availability.

- Create a Loadbalancer to connect and distribute traffic to the control planes' kube api servers.

- Create a __bastion host__ to securely access the control planes.

- Create a Private network with 3 private subnets(for the control planes) and 1 public subnet(for the bastion).

- Deploy the control planes in the 3 private subnets so we do not have a single point of failure.

- Manage the infrastructure using IAC tools (eg Terraform and Packer) to save time and reduce human error during setup.

I will be using the __Ubuntu 24.04__ as the base OS
and Kubernetes version __v1.30.3__  for the setup to meet the task requirement. 

__Infrastructure setup__

The terraform code creates 8 Virtual Machines:
- 3 Virtual machines for the control planes
- 3 Virtual machines for worker nodes (using auto scaling group) to scale the worker nodes depending on the workload.
- 1 loadbalancer to route traffic to the control plane.
- 1 Bastion host to securelt access the nodes.
- Private network (3 private and 1 public subnets)
- 2 security groups - 1 for the nodes and 1 for the bastion host
  - Port __22__ for secure connection in both security groups.

  Inbound traffic on the following ports in the __node security group__
  - ports __2379 and 2380__ for etcd communication between control planes on the subnets.
  - Ports __3000-32767__ for communication within the subnet to connect on ports used by the worker nodes.
  - Port __6443__ used by the kubernetes api to communicate with the cluster.
  - Port __80__ used to access the cluster from the browser.
- Alarms for CPU and Memory monitoring.

Install __Terraform__ and __Packer__.

Build the image for the nodes to install the kubernetes components which include ( __kubectl__, __kubeadm__, __kublet__ and __docker__) and disable swap memory which is required for kubernetes operation.

`cd ami`

Run the command to install the kubernetes components and create an __ami__ which will be used in the terraform code to set up the infrastructure.

`packer build .`

add the ami ID from the packer build to the __terraform.tfvars__

Run

`terraform plan`

`terraform apply`

Connect to the __control plane1__ through the __bastion host__

Run the `kubeadm init` command to initialize a kubernetes cluster in the __control plane1__

`sudo kubeadm init --control-plane-endpoint "<LOAD_BALANCER_IP>:6443" --upload-certs --pod-network-cidr=192.168.0.0/16`

The above command initializes the node as a control plane:

- Sets up the control plane components - __kube api server__, __kube controller manager__, __etcd__ and __kube scheduler__.

- Specifies the endpoint for the kubernetes Kube api server which is the loadbalancer

- Allows the kubeadm to upload the certificates to a central location(provided by kubeadm for storing and distributing certificates) where it can be retrieved when setting up the other control planes.

- Defines the CIDR block for the pod network for interraction between the pods.

Copy out the __join commands__ for the __control planes__ and __worker nodes__.

These will be used to join the control planes and worker nodes to the cluster respectively.

Setup the config file for the first control planes to interract with the cluster

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Install calico network plugin which is responsible for defining the networking rules that control the traffic and assigns IP address to the pods.

Download the calico manifest
`curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/calico.yaml -O`

Uncomment this section in the __calico.yaml__ file to suit our POD CIDR 192.168.0.0/16

```
- name: CALICO_IPV4POOL_CIDR
  value: "192.168.0.0/16"
```
Then apply

`kubectl apply -f calico.yaml`

Install ingress controller to act as a reverse proxy and loadbalancer to route traffic to the pods

`kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.49.0/deploy/static/provider/baremetal/deploy.yaml`

__Join the second and third control planes__

Log into the second control plane, and use the control plane join command to join it to the cluster

`sudo kubeadm join LOAD_BALANCER_IP:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash> --control-plane --certificate-key <certificate-key>`

Setup the config file for the first control planes to interract with the cluster

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Do the above for the third control plane.

__Join the worker nodes__

Run the worker node join command on each worker node.

`sudo kubeadm join LOAD_BALANCER_IP:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>`


__Verify the cluster__

To check the health status of the ETCD cluster which is the key value store of the cluster.

Install __etcdctl__ - a tool used to connect to the etcd

```
sudo apt-get update
sudo apt-get install etcd-client -y
```
Then run the command

`ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/peer.crt --key=/etc/kubernetes/pki/etcd/peer.key endpoint health`

This diplays the health of the etcd.


Check the ETCD cluster membership

`ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/peer.crt --key=/etc/kubernetes/pki/etcd/peer.key member list`

This will display the IDs, states and URLs of the etcd members.


Access the cluster from any of the control planes using the command

`kubectl get nodes` 

To acces the cluster from the bastion, copy the __kubeconfig__ file from the First control plane and put it in the `$HOME/.kube` path.

To check the health of the cluster from the HAProxy dashboard

In this section of the __haproxy-config.sh__ script used to configure the loadbalancer, we specified the port `8500` which will be used to access the loadbalancer from the browser.

```
listen stats
    bind *:8500
    mode http
    stats enable
    stats uri /
    stats refresh 10s
    stats admin if LOCALHOST
```

Restart HAProxy

`sudo systemctl restart haproxy`

Access the dashboard from the browser

`<LOAD_BALANCER_IP>:8500`

__Deploy the helm chart application__

Create a namespace for the application

`kubectl create ns syself`

Clone the github repository containing the helm chart

`git clone <github-repository-link>`

Deploy the helm chart into a kubernetes cluster

`helm install syself-app ./syself-helm-chart -n syself`

