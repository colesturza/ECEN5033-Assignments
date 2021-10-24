
1. Use the Vagrant file exactly as I provide, and do vagrant up.  You can increase memory and CPU, but do not decrease.
2. (from host OS), copy part1.sh and part2_master.sh into machine1_data
3. ssh into machine1
4. (if you're not already there) cd /home/vagrant
5. cp /vagrant_data/* .
6. chmod +x *.sh
7. ./part1.sh

8.   sudo vi /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
Modify line (last line):
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS
to
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS --node-ip=192.168.33.10

9. ./part2_master.sh

Note what was printed out, there should be a command that looks like.

kubeadm join 192.168.33.10:6443 --token fmjd4k.35gh8kccpx47mliz \
        --discovery-token-ca-cert-hash sha256:34a59dfa77699192fab12e19d38cb7233f786819192d5fe9b57399ded1c47c26

Copy that command.

(optional step) you can validate that the above all worked with the following command.  If you see a list of things, that's a good sign:
sudo kubectl get pods --all-namespaces


9. ssh into machine 2.
10. cp /vagrant/machine1_data/part1.sh .
11. chmod +x part1.sh
12. ./part1.sh

13.   sudo vi /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
Modify line (last line):
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS
to
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS --node-ip=192.168.33.11


13. paste the command as output above, but do it as super user (sudo at beginning), and append --node-name machine2 to the end. Note, you can continue the command on a new line by using \.  Example below:
kubeadm join 192.168.33.10:6443 --token fmjd4k.35gh8kccpx47mliz \
        --discovery-token-ca-cert-hash sha256:34a59dfa77699192fab12e19d38cb7233f786819192d5fe9b57399ded1c47c26 \
        --node-name machine2

(optional to test that it worked - on machine1 run the below command, and you should see machine1 and machine2)
kubectl get nodes

9. ssh into machine 3.
10. cp /vagrant/machine1_data/part1.sh .
11. chmod +x part1.sh
12. ./part1.sh

13. sudo vi /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
Modify line (last line):
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS
to
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS --node-ip=192.168.33.12


13. paste the command as output above, but do it as super user (sudo at beginning), and append --node-name machine3 to the end. Note, you can continue the command on a new line by using \.  Example below:
sudo kubeadm join 192.168.33.10:6443 --token fmjd4k.35gh8kccpx47mliz \
        --discovery-token-ca-cert-hash sha256:34a59dfa77699192fab12e19d38cb7233f786819192d5fe9b57399ded1c47c26 \
        --node-name machine3

(optional to test that it worked - on machine1 run the below command, and you should see machine1 and machine2 and machine3)
kubectl get nodes
