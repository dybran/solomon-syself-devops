## SYSELF KUBERNETES CLUSTER
Some of the major components of a kubernetes cluster include

- __Control plane (Master Nodes):__ - This is the brain of the cluster which  schedules workloads and manages the state of the application and cluster. These tasks are carried out by the master nodes using these components.
  - __Kube-apiserver:__ This is where client connect to the kubernetes API. It recieves requests and processes the request which is used to update the state of the cluster. 
  - __Kube-scheduler:__ This assigns newly created pods to pods based on the availability of resources and other factors in the pod.
  - __Kube-controller-manager:__ This manages the state of the kubernetes cluster which include replication, node management and general state management.
  - __etcd:__ Kubernetes is a stateless machine. The etcd is a distributed key value store that stores the state of the cluster which include the details of the nodes, pods and service.


__Worker Node:__ This handles the workload of the containers. This consists of various components that work together to achieve this. They include:

  - __Kubelet:__ This communicates with the control plane to recieves instructions and report on the containers status in a pod.
  - __Kube-proxy:__ This handles network routing allowing communication between pods and services.

  - __Container Runtime:__ This runs and manages the containers on the node.

  - __Pod:__ This is the smallest unit in a kubernetes cluster that is deployable.

A production grade kubernetes cluster needs to be highly available, scalable and resilient. We need atleast 3 master nodes to maintain __Quorum__ which is the minimum number of master nodes to be set up which helps with decision making.

I will be using the __Ubuntu 24.04__ as the base OS
and Kubernetes version __v1.30.3__  for the setup to meet the task requirement. 

__Prerequisites__

- 3 master nodes 
- 3 worker nodes
- 1 load balancer node

__Setting up the load balancer__

Create a Virtual Machine for the load balancer

!

__Install HAProxy:__

```
sudo apt-get update
sudo apt-get install -y haproxy
```






sudo chown -R root:root /etc/kubernetes/
sudo chmod -R 755 /etc/kubernetes/



add `sudo` to the join command for the 2nd and 3rd masters


use 192.168.0.0/16 or 172.16.0.0/12 for pod cidr

$ scp -i syself-key.pem deployment.yaml service.yml ubuntu@18.246.168.69:/tmp/
