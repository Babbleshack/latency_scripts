#!/bin/bash
TARGETS="1.1.1.1/32,8.8.8.8/32"
HADOOP_CONTAINER="k8s_yarn-master_yarn-master-0_yarn-subcluster-a_475f0799-27f4-4ed0-b230-b307818c377c_0"
./pumba-bin --interval=601s netem --target=${TARGETS} --tc-image=gaiadocker/iproute2 --duration=600s delay --time=3000 --jitter=20 ${HADOOP_CONTAINER} 
