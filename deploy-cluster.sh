#!/bin/bash - 
#===============================================================================
#
#          FILE: deploy-traefik.sh
# 
#         USAGE: ./deploy-traefik.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: N/A
#  REQUIREMENTS: Docker and Helm needs to be installed
#          BUGS: N/A
#         NOTES: N/A
#        AUTHOR: ONUR YASARLAR (yasarlaro) 
#  ORGANIZATION: N/A
#===============================================================================
set -o nounset                              # Treat unset variables as an error

# VARIABLES
CLUSTER_NAME="mycluster"
SERVER_COUNT=1
NODE_COUNT=3
TRAEFIK_LABEL="app.kubernetes.io/instance=traefik"

# Create Cluster
k3d cluster create ${CLUSTER_NAME} --api-port 127.0.0.1:6443 \
-p 80:80@loadbalancer \
-p 443:443@loadbalancer \
--k3s-server-arg "--no-deploy=traefik" --agents ${NODE_COUNT} --servers ${SERVER_COUNT}

# Install Traefik V2
helm repo add traefik https://containous.github.io/traefik-helm-chart
helm install traefik traefik/traefik

# Wait until Traefik deployment is finished
while [[ $(kubectl get pods -l "${TRAEFIK_LABEL}" -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]
do 
  sleep 1
done

# Expose Traefik Dashboard
kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name) 9000:9000 &
echo "You can reach Traefik dashbaord by: http://localhost:9000/dashboard/"

# Set cluster context to new cluster
kubectl config use-context k3d-${CLUSTER_NAME}

# Show cluster info
kubectl cluster-info

