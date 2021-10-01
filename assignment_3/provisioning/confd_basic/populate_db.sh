echo "CREATE A DIR AND ADD SOME KEY/VAL PAIRS"
etcdctl mkdir mykeys
etcdctl set mykeys/key1 1.2.3.4:1111
etcdctl set mykeys/key2 2.3.4.5:2222

echo "SEE IF THEY WERE WRITTEN:"
etcdctl ls
etcdctl ls mykeys
etcdctl get mykeys/key1
etcdctl get mykeys/key2

