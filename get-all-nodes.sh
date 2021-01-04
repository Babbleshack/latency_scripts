#!/bin/bash

### 
# Get all nodes across federation
###
kubectl get nodes -o wide -A -l 'subcluster in (home, local, remote)' | awk 'NR>1 {print $1, $6}' > all-nodes
