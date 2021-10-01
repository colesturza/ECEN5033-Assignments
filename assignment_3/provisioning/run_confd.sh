#!/bin/bash

sudo docker run -v /home/vagrant/confd:/etc/confd \
  -v /home/vagrant/tmp:/tmp \
  -it dockage/confd:latest confd \
  -onetime \
  -backend etcd \
  -node http://192.168.33.10:2379
