#!/bin/bash
SUBCLUSTER_A="yarn-subcluster-a"
SUBCLUSTER_B="yarn-subcluster-b"
SUBCLUSTER_C="yarn-subcluster-c"
kubectl get pods -n ${SUBCLUSTER_A}  -o wide | tail -n +2 | awk '{print $6}' > home-subcluster \
&& kubectl get pods -n ${SUBCLUSTER_B}  -o wide | tail -n +2 | awk '{print $6}' > local-subcluster \
&& kubectl get pods -n ${SUBCLUSTER_C}  -o wide | tail -n +2 | awk '{print $6}' > remote-subcluster
cat home-subcluster local-subcluster > home-and-local-subclusters
