#!/bin/bash

echo "SET STATE VARIABLES IN ETCD"
etcdctl mkdir color
etcdctl set color/current_color green
