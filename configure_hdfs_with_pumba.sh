#!/bin/bash

ADD_LATENCY_TAR="add_latency.tar.gz"

#mkdir add_hdfs_latency
#pushd add_hdfs_latency

#Collect all HDFS nodes
nodes=$(kubectl get pods -n hdfs -o wide | tail -n+2 | awk '{print $7}')

##Get Yarn-Subcluster-C worker IP's
kubectl get pods -n yarn-subcluster-c -o wide | tail -n+2 | awk '{print $6}' > remote_sc_ips.txt 

#Collect HDFS node IP's (NOTE: These are the nodes hosting the hdfs containers)
rm nodes.txt
touch nodes.txt
declare -a node_ips
for node in $nodes
do
	node_ips+=($(kubectl get node $node -o wide | tail -n+2 | awk '{print $6}'))
	echo $(kubectl get node $node -o wide | tail -n+2 | awk '{print $6}') >> nodes.txt
done

echo ${node_ips[@]}

# Copy scripts to HDFS nodes 
echo "Copying scripts to hdfs nodes"
for node in `cat nodes.txt`; do 
	ssh root@$node "rm /root/remote_sc_ips.txt"
	scp ./run_pumba_hdfs.sh root@$node:/root/run_pumba.sh
	scp ./remote_sc_ips.txt root@$node:/root/remote_sc_ips.txt
done	

##Run Pumba
echo "Running Pumba"
declare -a pids
for node in `cat nodes.txt`; do 
	ssh root@$node "docker stop pumba; /root/run_pumba.sh /root/remote_sc_ips.txt 5 2" &
	pids+=($!)
done	
for pid in ${pids[@]}
do
	wait "$pid"
done
