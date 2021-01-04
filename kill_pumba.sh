#!/bin/bash
declare -a pids
for node in `cat nodes/all-nodes`
do
	ssh root@$node docker stop pumba &
	pids+=($!)
done	
for pid in ${pids[@]}
do
	wait "$pid"
done
