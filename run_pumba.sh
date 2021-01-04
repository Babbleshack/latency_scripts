#!/bin/bash
NODES_FILE=$1
P_DELAY=${2:-22}
DEVIATION=${3:-10}
LOG_LEVEL="none"

YARN_CONTAINER_REGX="re2:k8s_yarn-.*_.*_yarn-subcluster-*"
IP_LIST=""

#Build up IP List
list=`head -n1 $NODES_FILE`
for ip in `tail -n+2 $NODES_FILE`
do
        list="$list,${ip}"
done
IP_LIST=${list}

#Stop any old instances
#docker stop pumba

echo "Pumba Delay $P_DELAY, Deviation: $DEVIATION\n"
#Start Pumba
docker run --rm -d --name pumba -v /var/run/docker.sock:/var/run/docker.sock babbleshack/pumba:dirty \
        --interval=601s netem \
        --target=${IP_LIST} --tc-image=gaiadocker/iproute2 \
        --duration=600s delay --time=${P_DELAY} --jitter=$DEVIATION "re2:k8s_yarn-.*_.*_yarn-subcluster-*"
