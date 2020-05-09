#!/bin/bash
kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

# install Tekton cli
curl -LO https://github.com/tektoncd/cli/releases/download/v0.9.0/tkn_0.9.0_Linux_x86_64.tar.gz
sudo tar xvzf tkn_0.9.0_Linux_x86_64.tar.gz -C /usr/local/bin/ tkn

# wait for Tekton to be ready
tries=0
until (kubectl get pod -n tekton-pipelines | grep -v NAME)>/dev/null || [ $tries -eq 60 ]; do
  tries=$((tries + 1))
  sleep 1
done
kubectl wait --for=condition=ready pod --all -n tekton-pipelines --timeout=2m
sleep 1
