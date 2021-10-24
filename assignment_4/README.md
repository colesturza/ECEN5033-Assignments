# Assignment 4

Assignment 4 for ECEN5033 DevOps in the Cloud.

# Commands

Follow the setup instructions in `k8_installation_for_class`
to initialize the Kubernetes cluster.

On each machine run the following.

```bash
sudo docker run -d -p 5000:5000 --restart=always --name registry registry:2
```

Edit `/etc/docker/daemon.json`, adding `"insecure-registries":["192.168.33.10:5000"]`
inside the `{ }` (you’ll need a comma on the current last entry).

```bash
sudo service docker restart
```
