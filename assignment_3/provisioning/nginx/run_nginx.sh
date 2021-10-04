docker run -d --name nginx-container \
  -v /home/vagrant/nginx/etc_nginx:/etc/nginx \
  -p 80:80 \
  nginx
