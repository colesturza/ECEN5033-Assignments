#!/bin/bash

docker run --name my-custom-nginx-container \
  -v /home/vagrant/nginx_basic/ngx/etc_nginx:/etc/nginx \
  -p 80:80 -d nginx
