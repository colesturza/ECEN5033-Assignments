FROM centos:7.4.1708

# Make dirs
RUN mkdir -p /etc/confd/{conf.d,templates}

# Add templates
COPY /home/vagrant/confd/ /etc/confd/

# Add confd
ADD https://github.com/kelseyhightower/confd/releases/download/v0.14.0/confd-0.14.0-linux-amd64 /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd

# Set up the ENTRYPOINT
COPY /home/vagrant/confd/docker-entrypoint.sh /var/local/
RUN chmod a+x /var/local/docker-entrypoint.sh

ENTRYPOINT ["/var/local/docker-entrypoint.sh"]
