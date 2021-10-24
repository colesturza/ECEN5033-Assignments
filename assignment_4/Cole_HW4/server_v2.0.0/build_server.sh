sudo docker build -t serverapp:v2.0.0 .
sudo docker tag serverapp:v2.0.0 192.168.33.10:5000/serverapp:v2.0.0
sudo docker push 192.168.33.10:5000/serverapp:v2.0.0
