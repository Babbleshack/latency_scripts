#/bin/bash
list=`head -n1 subclusters/home-subcluster`
for ip in `tail -n+2 ./subclusters/home-subcluster`
do
	list="$list, ${ip}"
done
echo $list
