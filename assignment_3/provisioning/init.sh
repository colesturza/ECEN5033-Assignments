#!/bin/bash

echo "SET STATE VARIABLES IN ETCD"
etcdctl mkdir color
etcdctl set color/current_color green
etcdctl set color/blue_port 1080
etcdctl set color/green_port 1081
