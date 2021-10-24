sudo docker build -t serverapp:v1.0.0 .
sudo docker tag serverapp:v1.0.0 192.168.33.10:5000/serverapp:v1.0.0
sudo docker push 192.168.33.10:5000/serverapp:v1.0.0
