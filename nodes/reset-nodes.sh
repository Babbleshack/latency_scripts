#!/bin/bash
kubectl get nodes -l subcluster=home -o wide  | tail -n+2 | awk '{print $6}' > home-subcluster \
&& kubectl get nodes -l subcluster=local -o wide  | tail -n+2 | awk '{print $6}' > local-subcluster \
&& kubectl get nodes -l subcluster=remote -o wide  | tail -n+2 | awk '{print $6}' > remote-subcluster 
