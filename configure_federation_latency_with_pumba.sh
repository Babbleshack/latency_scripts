#!/bin/bash

ADD_LATENCY_TAR="add_latency.tar.gz"

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

tar czf ${ADD_LATENCY_TAR} ./run_pumba.sh ./nodes ./subclusters ./pumba-bin

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
	echo "untaring files at $node"
	ssh root@$node tar xzf ${ADD_LATENCY_TAR} &
done	
echo "Waiting"
for pid in ${pids[@]}
do
	wait "$pid"
done

DELAY=10
DEVIATION=5

declare -a pids
echo "========================"
echo "Add home latencies"
echo "========================"
for node in `cat nodes/home-subcluster`
do
	echo "Starting Pumba on Node: $node"
	ssh root@$node "pkill pumba"
	ssh root@$node  "/root/run_pumba.sh /root/subclusters/remote-subcluster ${DELAY} ${DEVIATION}"
done	

echo "========================"
echo "Add local latencies"
echo "========================"
for node in `cat nodes/local-subcluster`
do
	echo "Starting Pumba on Node: $node"
	ssh root@$node "pkill pumba"
	ssh root@$node  "/root/run_pumba.sh /root/subclusters/remote-subcluster ${DELAY} ${DEVIATION}"
done	

echo "========================"
echo "Add remote latencies"
echo "========================"
for node in `cat nodes/remote-subcluster`
do
	echo "Starting Pumba on Node: $node"
	ssh root@$node "pkill pumba"
	ssh root@$node  "/root/run_pumba.sh /root/subclusters/home-and-local-subclusters ${DELAY} ${DEVIATION}"
done	
