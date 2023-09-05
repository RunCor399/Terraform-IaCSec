#!/bin/bash
az login

# Automatic configuration of local kubectl
az aks get-credentials -g aks-resource-group -n aks-cluster

kubectl get nodes

# Deploy Service Account and Test Pod
#kubectl apply -f ./kubernetes_service_account.yml
#kubectl apply -f ./pod_service_account.yml

# Deploy Online Boutique
#kubectl apply -f ./kubernetes_manifest_edited.yml

# Deploy Spring DB Connector microservice
#kubectl apply -f ./db_connector_manifest.yml

# Deploy Kubernetes Dashboard
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

echo "Dashboard URL: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"

#Deploy Sysdig Agent
# helm repo add sysdig https://charts.sysdig.com
# helm repo update
# helm install sysdig-agent --namespace sysdig-agent --create-namespace \
#     --set global.sysdig.accessKey=fd19e5cc-9261-4c5f-827e-bbc855c83861 \
#     --set global.sysdig.region=eu1 \
#     --set nodeAnalyzer.secure.vulnerabilityManagement.newEngineOnly=true \
#     --set global.kspm.deploy=true \
#     --set nodeAnalyzer.nodeAnalyzer.benchmarkRunner.deploy=false \
#     --set global.clusterConfig.name=aks-cluster \
#     sysdig/sysdig-deploy

# Proxy access to kubernetes dashboard
#kubectl proxy


# Dashboard: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/