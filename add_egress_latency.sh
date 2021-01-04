#!/bin/bash
#INTERFACE=${1:-enp3s0}
INTERFACE=$(ip a | grep "2: enp" | awk '{print $2}' | sed 's/@.*//g')
NODES_FILE=${1:-"./subcluster-nodes"}
DELAY=${2:-35ms}
DEVIATION=${3:-10ms}

# CLear any previous schedulers
echo "Cleaning qdisks ${INTERFACE}"
tc qdisc del dev ${INTERFACE} root
set -e
echo "Creating Handle"
tc qdisc add dev ${INTERFACE} root handle 1: prio
echo "Adding Delay mean=${DELAY} sd=${DEVIATION}"
tc qdisc add dev ${INTERFACE} parent 1:3 handle 30: netem delay ${DELAY} ${DEVIATION}
for ip in `cat $NODES_FILE` 
do
	echo "Filtering to ${ip}"
	tc filter add dev ${INTERFACE} protocol ip parent 1:0 prio 3 u32 \
		match ip dst ${ip} flowid 1:3
done



