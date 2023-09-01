#!/bin/bash

helm repo add sysdig https://charts.sysdig.com
helm repo update
helm install sysdig-agent --namespace sysdig-agent --create-namespace \
    --set global.sysdig.accessKey=41446d91-a0b9-4930-abbb-e2dc391ca564 \
    --set global.sysdig.region=eu1 \
    --set nodeAnalyzer.secure.vulnerabilityManagement.newEngineOnly=true \
    --set global.kspm.deploy=true \
    --set nodeAnalyzer.nodeAnalyzer.benchmarkRunner.deploy=false \
    --set global.clusterConfig.name=eks-lab-cluster-module \
    sysdig/sysdig-deploy
