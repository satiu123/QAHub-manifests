#!/bin/bash

ENVIRONMENT="dev"

echo "INFO - Deploying CRDs..."
# 1. 部署 CRDs 
kubectl apply -k crds/

echo "INFO - Waiting for CRDs to be established..."
sleep 10

echo "INFO - Deploying Infrastructure components..."
# 2. 部署基础设施
kustomize build --enable-alpha-plugins --enable-exec apps/infra | kubectl apply -f -

echo "INFO - Waiting for infrastructure deployments to be ready..."
sleep 10

echo "INFO - Deploying Applications for environment: $ENVIRONMENT..."
# 3. 部署无状态应用
kustomize build --enable-alpha-plugins --enable-exec apps/overlays/${ENVIRONMENT} | kubectl apply -f -

echo "SUCCESS - Deployment finished for environment: $ENVIRONMENT"