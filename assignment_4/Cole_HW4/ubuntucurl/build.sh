sudo docker build -t ubuntucurl .
sudo docker tag ubuntucurl 192.168.33.10:5000/ubuntucurl
sudo docker push 192.168.33.10:5000/ubuntucurl
