#!/bin/bash

sudo docker run -d -v /usr/share/ca-certificates/:/etc/ssl/certs \
  -p 2380:2380 -p 2379:2379  \
  --name etcd quay.io/coreos/etcd:v2.3.8  \
  --advertise-client-urls http://192.168.33.10:2379 --listen-client-urls http://0.0.0.0:2379
