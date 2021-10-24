sudo docker build -t cole-ubuntucurl .
sudo docker tag cole-ubuntucurl 192.168.33.10:5000/cole-ubuntucurl
sudo docker push 192.168.33.10:5000/cole-ubuntucurl
