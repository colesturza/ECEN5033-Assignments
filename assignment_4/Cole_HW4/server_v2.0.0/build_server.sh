sudo docker build -t cole-serverapp:v2.0.0 .
sudo docker tag cole-serverapp:v2.0.0 192.168.33.10:5000/cole-serverapp:v2.0.0
sudo docker push 192.168.33.10:5000/cole-serverapp:v2.0.0
