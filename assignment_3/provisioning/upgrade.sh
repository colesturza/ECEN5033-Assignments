#!/bin/bash

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    echo "upgrade <new_version_directory>"
    echo "    new_version_directory should the directory of the new server version."
    exit 1
fi

NEW_VERSION_DIRECTORY=$1
if [ ! -d "$NEW_VERSION_DIRECTORY" ]; then
  echo "Provided new version directory does not exist."
  exit 1
fi

CURRENT_COLOR=$(etcdctl get color/current_color)
NEW_COLOR="NONE"
if [ "$CURRENT_COLOR" == "NONE" ]; then
  NEW_COLOR="BLUE";
elif [ "$CURRENT_COLOR" == "BLUE" ]; then
  NEW_COLOR="GREEN";
elif [ "$CURRENT_COLOR" == "GREEN" ]; then
  NEW_COLOR="BLUE";
else
  echo "CURRENT_COLOR is neither NONE, BLUE, nor GREEN."
  exit 1
fi

SERVER_CONTAINER_NAME="server_${NEW_COLOR}"

# build and run the new server version container
docker build -t server "$NEW_VERSION_DIRECTORY"
docker run -d -p :80 --name "$SERVER_CONTAINER_NAME" server

# run confd
bash run_confd

# retrieve new nginx config file
cp /home/vagrant/confd/out/nginx.conf /home/vagrant/nginx/etc_nginx

# reload nginx
docker container exec nginx-container nginx -s reload

# stop and remove all the old containers
docker stop "server_${CURRENT_COLOR}"
bash remove_exited_containers.sh
