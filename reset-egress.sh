#!/bin/bash

ADD_LATENCY_TAR="add_latency.tar.gz"

set -e

#echo "Getting node ip's"
#pushd nodes
#./get-node-ips.sh
#cat home-subcluster local-subcluster remote-subcluster > all-nodes
#popd

for node in `cat nodes/all-nodes`
do
	echo "Resetting ${node}"
	ssh root@$node tc qdisc del dev flannel.1 root &
	ssh root@$node tc qdisc del dev enp3s0 root &
done	
wait $!
