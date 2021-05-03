# k8s-homelab

## Getting Started
This project is to build a local development or test environment for Kubernetes workloads. It uses **k3d** which is a lightweight wrapper to run k3s (Rancher Lab’s minimal Kubernetes distribution) in docker. Please refer to [official website](https://k3d.io/) for more information.

The project does not install Traefik V1 that comes with K3d by default. Instead it installs Traefik V2 with a Helm chart and exposes its dashboard on localhost over port 9000.

## Prerequisites
Docker and Helm needs to be installed on your local development environment.

## Installation
Please review the deployment script and edit below variables for your environment.

CLUSTER_NAME: The name of your local development cluster
SERVER_COUNT: Number of master nodes
NODE_COUNT: Number of worker nodes

Once the variables are edited, you can run the deployment as below:

```sh
chmod +x ./deploy-cluster.sh
././deploy-cluster.sh
```

## Deployment Samples

### Vault
You can deploy Hashicorp Vault via `kubectl apply -f ./vault` command. It will create 2 persistent volumes with 5 GiB to mount `/vault/logs` and `/vault/files` directories. Deployment also creates an `ingress` resource and you can access it either via hostname or host path. Please review the `vault/vault-ingress.sh` file and decide which way you want to proceed. If you want to proceed with host option, please add your FQDN to your `/etc/hosts` file or your DNS server. 
In order to get the root token after the initial deployment, you can review the logs of the newly created pod and take it by:
```sh
kubectl logs vault-XXXXXXXXX | grep "Root Token"
```

### Nexus
You can deploy Nexus via `kubectl apply -f ./nexus` command. It will create a persistent volumes with 50 GiB to mount `/nexus/data` directory. Deployment also creates an `ingress` resource and you can access it either via hostname or host path. Please review the `nexus/nexus-ingress.sh` file and decide which way you want to proceed. If you want to proceed with host option, please add your FQDN to your `/etc/hosts` file or your DNS server. 
In order to get admin password after the initial deployment, you can run below command:
```sh
kubectl exec nexus-XXXXXXXXX -- cat /nexus-data/admin.password
```
