#!/bin/bash

# start etcd and the registrator
bash run_etcd.sh 1 1
bash run_registrator.sh

# set default values for blue/green update variables
etcdctl mkdir color
etcdctl set color/current_color NONE

# start nginx
cd nginx || exit
bash build_nginx.sh
bash run_nginx.sh
cd - || exit