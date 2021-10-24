# Assignment 4

Assignment 4 for ECEN5033 DevOps in the Cloud.

# Instructions

1. Follow the setup instructions in `k8_installation_for_class`
to initialize the Kubernetes cluster.

2. On each machine run the following.

    ```bash
    sudo docker run -d -p 5000:5000 --restart=always --name registry registry:2
    ```

    Edit `/etc/docker/daemon.json`, adding `"insecure-registries":["192.168.33.10:5000"]`
    inside the `{ }` (you’ll need a comma on the current last entry).

    ```bash
    sudo service docker restart
    ```

3. Copy `Cole_HW4` into `machine1_data` from outside of the VMs,
then run the following command from inside machine1:

    ```bash
    cp -r /vagrant/machine1_data/* /home/vagrant/
    ```

4. Follow the instructions inside `Cole_HW4` to run the rest of then
assignment.
