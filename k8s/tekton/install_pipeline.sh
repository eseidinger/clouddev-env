#!/usr/bin/env bash

kubectl create namespace tekton-tasks
tkn hub install task -n tekton-tasks git-clone
tkn hub install task -n tekton-tasks kaniko
kubectl apply -n tekton-tasks -f pipeline.yaml 
