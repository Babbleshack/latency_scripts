#!/bin/bash

ADD_LATENCY_TAR="add_latency.tar.gz"

set -e

echo "Getting node ip's"
pushd nodes
./get-node-ips.sh
cat home-subcluster local-subcluster remote-subcluster > all-nodes
popd

echo "Getting subcluster ip's"
pushd subclusters
./get-subcluster-ips.sh
cat home-subcluster local-subcluster remote-subcluster > all-nodes
popd

tar czf ${ADD_LATENCY_TAR} ./add_pod_egress_latency_to_node.sh ./nodes ./subclusters

declare -a pids
echo "Copying tar to nodes"
for node in `cat nodes/all-nodes`
do
	echo "Copying files to $node"
	scp ${ADD_LATENCY_TAR} root@$node:/root/${ADD_LATENCY_TAR} & 
	pids+=($!)
done	
echo "Waiting"
for pid in ${pids[@]}
do
	wait "$pid"
done

declare -a pids
for node in `cat nodes/all-nodes`
do
	echo "Copying files to $node"
	ssh root@$node tar xzf ${ADD_LATENCY_TAR} &
done	
echo "Waiting"
for pid in ${pids[@]}
do
	wait "$pid"
done

declare -a pids
echo "Add home latencies"
for node in `cat nodes/home-subcluster`
do
	ssh root@$node /root/add_pod_egress_latency_to_node.sh subclusters/remote-subcluster
done	
echo "Waiting"
for pid in ${pids[@]}
do
	wait "$pid"
done
#
#echo "Add local latencies"
#for node in `cat nodes/home-subcluster`
#do
#	ssh root@$node tar xzf ${ADD_LATENCY_TAR} & 
#	ssh root@$node /root/add_pod_egress_latency.sh subclusters/remote-subcluster &
#done	
#wait $!
#
#echo "Add remote latencies"
#for node in `cat nodes/home-subcluster`
#do
#	ssh root@$node tar xzf ${ADD_LATENCY_TAR}
#	ssh root@$node /root/add_pod_egress_latency.sh subclusters/home-subcluster &
#	ssh root@$node /root/add_pod_egress_latency.sh subclusters/local-subcluster &
#done	
#wait $!
