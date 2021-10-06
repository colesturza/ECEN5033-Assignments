#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "No arguments provided"
    echo "upgrade <new_version_directory>"
    echo "    new_version_directory should the directory of the new server version."
    exit 1
fi

NEW_VERSION_DIRECTORY=$1
if [[ ! -d $NEW_VERSION_DIRECTORY ]]; then
  echo "Provided new version directory does not exist."
  exit 1
fi

# number of apps to deploy
NUM_OF_APPS_TO_DEPLOY=${2:-1}


CURRENT_COLOR=$(etcdctl get color/current_color)
NEW_COLOR="none"
if [[ $CURRENT_COLOR == "none" ]]; then
  NEW_COLOR="blue";
elif [[ $CURRENT_COLOR == "blue" ]]; then
  NEW_COLOR="green";
elif [[ $CURRENT_COLOR == "green" ]]; then
  NEW_COLOR="blue";
else
  echo "CURRENT_COLOR is neither none, blue, nor green."
  exit 1
fi


SERVER_CONTAINER_NAME="server_${NEW_COLOR}"

# build and run the new server version containers
docker build -t "server_image_${NEW_COLOR}" "$NEW_VERSION_DIRECTORY"

i=1
while [[ $i -le $NUM_OF_APPS_TO_DEPLOY ]]; do
    docker run -d -p :80 --name "${SERVER_CONTAINER_NAME}_${i}" "server_image_${NEW_COLOR}"
    ((i++))
done


# run confd
cd confd || exit
bash run_confd.sh
cd - || exit

# retrieve new nginx config file
cp /home/vagrant/confd/out/nginx.conf /home/vagrant/nginx/etc_nginx

# reload nginx
docker container exec nginx-container nginx -s reload

# stop and remove all the old containers
if [[ $CURRENT_COLOR != "none" ]]; then
  # shellcheck disable=SC2046
  docker container stop $(docker container ls -q --filter name=server_"$CURRENT_COLOR"*)
fi
bash remove_exited_containers.sh

# set the current color to the new color
etcdctl set color/current_color "$NEW_COLOR"

echo "Started ${NUM_OF_APPS_TO_DEPLOY} new containers for ${NEW_VERSION_DIRECTORY} with color ${NEW_COLOR}."
