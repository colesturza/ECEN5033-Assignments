# Assignment 4

Assignment 4 for ECEN5033 DevOps in the Cloud.

# Instructions

**Assumptions:**
  * You have Kubernetes installed with 3 VMs (machine1-3), you
    will have a Registry running at 192.168.33.10:5000

**Part 1:**

1. Change directories using the `cd` command to the `Cole_HW4` directory.

2. Change directories to the `server_v1.0.0` directory. Run `cd server_v1.0.0/`
   from the `Cole_HW4` directory. Then, add execution permissions to the build
   script with `chmod +x *.sh`. Lastly, build the docker image with
   `bash build_server.sh`.

   To validate that the container was pushed to the registry
   run `curl 192.168.33.10:5000/v2/_catalog`. You should see the following output:

   ```
   {"repositories":["cole-serverapp"]}
   ```

3. Return to `Cole_HW4` directory.

4. Run the following command to create a ReplicationController for the server
   app.

   ```bash
   kubectl apply -f server_rc.yaml
   ```

   Creating a ReplicationController will ensure the scalability and
   fault tolerance of the server apps.

5. Run `kubectl get rc` to check if the ReplicationController was created.
   The output could be similar to the following:

   ```
   NAME                DESIRED   CURRENT   READY   AGE
   cole-serverapp-rc   3         3         3       7s
   ```

   Once the ReplicationController is created run `kubectl get pods` to check if
   three pods have been created. The output should be similar to the following:

   ```
   NAME                      READY   STATUS    RESTARTS   AGE
   cole-serverapp-rc-bqcbc   1/1     Running   0          17s
   cole-serverapp-rc-cpdk8   1/1     Running   0          17s
   cole-serverapp-rc-wqv45   1/1     Running   0          17s
   ```

6. To test the scalability of our deployment you can edit the `server_rc.yaml`
   file to increase/decrease the number of replicas. Then run
   `kubectl apply -f server_rc.yaml` and check if the number of pods matches
   the number of replicas set.

7. To test the fault tolerance of the deployment delete one of the pods with
   `kubectl delete pod cole-serverapp-rc-<id>`. Replace `<id>` with
   one of the hashes from the output from before. Then run `kubectl get pods`
   again, the same number of replicas should exist, plus there should be a new
   pod that was created. If decreasing the number of pods the output should
   be similar to the following:

   ```
   NAME                      READY   STATUS        RESTARTS   AGE
   cole-serverapp-rc-5fcdh   1/1     Terminating   0          34s
   cole-serverapp-rc-bqcbc   1/1     Running       0          2m12s
   cole-serverapp-rc-cpdk8   1/1     Running       0          2m12s
   cole-serverapp-rc-wqv45   1/1     Running       0          2m12s
   ```

   (This was going from 4 to 3 pods)

8. Now create a Service to load balance between the replicas. Run the following.

   ```bash
   kubectl apply -f server_svc.yaml
   ```

9. Check that the Service was properly created with `kubectl get svc`. The
   output should be similar to the following:

   ```
   NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
   cole-serverapp-svc   ClusterIP   10.107.83.175   <none>        80/TCP    4s
   kubernetes           ClusterIP   10.96.0.1       <none>        443/TCP   48m
   ```

   Take note of the IP address for the Service.

10. Change directories to the ubuntucurl directory. Run `cd ubuntucurl/` from
    the `Cole_HW4` directory. Then, add execution permissions to the build script
    with `chmod +x *.sh`. Lastly, build the docker image with
    `bash build.sh`.

    To validate that the container was pushed to the registry
    run `curl 192.168.33.10:5000/v2/_catalog`. You should see the following output:

    ```
    {"repositories":["cole-serverapp","cole-ubuntucurl"]}
    ```

11. Return to `Cole_HW4` directory.

12. Run the following to create the client pod:

    ```bash
    kubectl apply -f ubuntucurl.yaml
    ```

    Validate that the pod has been created with `kubectl get pods -o wide`. This will
    also validate that the nodeSelector is working properly too. The output should
    be similar to the following:

    ```
    NAME                      READY   STATUS    RESTARTS   AGE   IP            NODE       NOMINATED NODE   READINESS GATES
    cole-serverapp-rc-f9l5q   1/1     Running   0          4s    10.244.1.8    machine2   <none>           <none>
    cole-serverapp-rc-hwm8h   1/1     Running   0          4s    10.244.1.9    machine2   <none>           <none>
    cole-serverapp-rc-wp745   1/1     Running   0          4s    10.244.1.10   machine2   <none>           <none>
    cole-ubuntucurl           1/1     Running   0          12m   10.244.3.7    machine3   <none>           <none>
    ```

    You should see that all the server apps are running on machine2 and the client
    app is running on machine3.

13. To test the if the Service is working properly run the following:

    ```bash
    kubectl exec cole-ubuntucurl -- bash manycurl.sh 10.107.83.175:80
    ```

    You should use the IP address from the output of `kubectl get svc` from before.
    The output of the previous command should be similar to the following:

    ```
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                   Dload  Upload   Total   Spent    Left  Speed
    100    63  100    63    0     0  21000      0 --:--:-- --:--:-- --:--:-- 31500
    You've hit cole-serverapp-rc-bqcbc. A very interesting message.
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                   Dload  Upload   Total   Spent    Left  Speed
    100    63  100    63    0     0  31500      0 --:--:-- --:--:-- --:--:-- 31500
    You've hit cole-serverapp-rc-wqv45. A very interesting message.
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                   Dload  Upload   Total   Spent    Left  Speed
    100    63  100    63    0     0  63000      0 --:--:-- --:--:-- --:--:-- 63000
    You've hit cole-serverapp-rc-cpdk8. A very interesting message.
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                   Dload  Upload   Total   Spent    Left  Speed
    100    63  100    63    0     0  63000      0 --:--:-- --:--:-- --:--:-- 63000
    You've hit cole-serverapp-rc-cpdk8. A very interesting message.
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                   Dload  Upload   Total   Spent    Left  Speed
    100    63  100    63    0     0  31500      0 --:--:-- --:--:-- --:--:-- 31500
    You've hit cole-serverapp-rc-bqcbc. A very interesting message.
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                   Dload  Upload   Total   Spent    Left  Speed
    100    63  100    63    0     0  31500      0 --:--:-- --:--:-- --:--:-- 63000
    You've hit cole-serverapp-rc-cpdk8. A very interesting message.
    ...
    ```

    Use control+C to stop the command. You should see that the message changes
    depending on the pod that receives the request.

**Part 2:**

1. Run `kubectl apply -f server_dep.yaml` to create a Deployment. Run
   `kubectl get deployments` to check if the Deployment was created.

   If the Deployment is still being created, the output is similar to the
   following:

   ```
   NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
   cole-serverapp-dep   0/3     3            0           1s
   ```

   After a couple seconds the output should be similar to:

   ```
   NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
   cole-serverapp-dep   3/3     3            3           95s
   ```

2. Validate that the pods were created with `kubectl get pods`. The output
   should be similar to the following:

   ```
   NAME                                  READY   STATUS    RESTARTS   AGE
   cole-serverapp-dep-65959f65c5-lxbkv   1/1     Running   0          2m29s
   cole-serverapp-dep-65959f65c5-mn4wr   1/1     Running   0          2m29s
   cole-serverapp-dep-65959f65c5-v9cqx   1/1     Running   0          2m29s
   cole-serverapp-rc-f9l5q               1/1     Running   0          12m
   cole-serverapp-rc-hwm8h               1/1     Running   0          12m
   cole-serverapp-rc-wp745               1/1     Running   0          12m
   cole-ubuntucurl                       1/1     Running   0          24m
   ```

   You should see both the pods from the Deployment and the ReplicationController.

3. Open a new terminal and ssh into machine1. Run
   `kubectl exec cole-ubuntucurl -- bash manycurl.sh 10.107.83.175:80` using the
   same IP as before.

4. Switch back to the original terminal and now delete the
   ReplicationController with `kubectl delete rc cole-serverapp-rc`.

   The pods controlled by the ReplicationController should now be marked as
   "Terminating" when running `kubectl get pods`. The Service should be load
   balancing between the server apps controlled by the ReplicationController and
   the Deployment. You can validate this by checking if the messages in the other
   terminal failed to connect with a server app.

   After a few seconds the output of `kubectl get pods` should be similar to the
   following:

   ```
   NAME                                  READY   STATUS    RESTARTS   AGE
   cole-serverapp-dep-65959f65c5-lxbkv   1/1     Running   0          10m
   cole-serverapp-dep-65959f65c5-mn4wr   1/1     Running   0          10m
   cole-serverapp-dep-65959f65c5-v9cqx   1/1     Running   0          10m
   cole-ubuntucurl                       1/1     Running   0          32m
   ```

5. Change directories to the `server_v2.0.0` directory. Run `cd server_v2.0.0/`
   from the `Cole_HW4` directory. Then, add execution permissions to the build
   script with `chmod +x *.sh`. Lastly, build the docker image with
   `bash build_server.sh`.

   To validate that the container was pushed to the registry
   run `curl 192.168.33.10:5000/v2/cole-serverapp/tags/list`.
   You should see the following output:

   ```
   {"name":"cole-serverapp","tags":["v2.0.0","v1.0.0"]}
   ```

6. Now update the server app using the following command:

   ```bash
   kubectl set image deployments/cole-serverapp-dep cole-serverapp=192.168.33.10:5000/cole-serverapp:v2.0.0
   ```

   You should see something similar to the following when running `kubectl get pods`.

   ```
   NAME                                  READY   STATUS              RESTARTS   AGE
   cole-serverapp-dep-65959f65c5-lxbkv   1/1     Terminating         0          34m
   cole-serverapp-dep-65959f65c5-mn4wr   1/1     Running             0          34m
   cole-serverapp-dep-65959f65c5-v9cqx   1/1     Terminating         0          34m
   cole-serverapp-dep-69b9b4ddcd-rq59r   1/1     Running             0          7s
   cole-serverapp-dep-69b9b4ddcd-wbdj2   1/1     Running             0          4s
   cole-serverapp-dep-69b9b4ddcd-zl9m5   0/1     ContainerCreating   0          2s
   cole-ubuntucurl                       1/1     Running             0          56m
   ```

   In the other terminal the messages should eventually switch over to
   "Another very interesting message." from "A very interesting message."
   The output at the switch should look similar to the following:

   ```
   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                  Dload  Upload   Total   Spent    Left  Speed
   100    75  100    75    0     0  37500      0 --:--:-- --:--:-- --:--:-- 37500
   You've hit cole-serverapp-dep-65959f65c5-lxbkv. A very interesting message.
   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                  Dload  Upload   Total   Spent    Left  Speed
   100    75  100    75    0     0  37500      0 --:--:-- --:--:-- --:--:-- 75000
   You've hit cole-serverapp-dep-65959f65c5-lxbkv. A very interesting message.
   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                  Dload  Upload   Total   Spent    Left  Speed
   0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
   You've hit cole-serverapp-dep-69b9b4ddcd-rq59r. Another very interesting message.
   100    81  100    81    0     0  40500      0 --:--:-- --:--:-- --:--:-- 40500
   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                  Dload  Upload   Total   Spent    Left  Speed
   100    75  100    75    0     0  37500      0 --:--:-- --:--:-- --:--:-- 37500
   You've hit cole-serverapp-dep-65959f65c5-mn4wr. A very interesting message.
   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                  Dload  Upload   Total   Spent    Left  Speed
   100    81  100    81    0     0  27000      0 --:--:-- --:--:-- --:--:-- 40500
   You've hit cole-serverapp-dep-69b9b4ddcd-wbdj2. Another very interesting message.
   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                  Dload  Upload   Total   Spent    Left  Speed
   100    75  100    75    0     0  37500      0 --:--:-- --:--:-- --:--:-- 75000
   You've hit cole-serverapp-dep-65959f65c5-mn4wr. A very interesting message.
   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                  Dload  Upload   Total   Spent    Left  Speed
   0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
   You've hit cole-serverapp-dep-69b9b4ddcd-rq59r. Another very interesting message.
   100    81  100    81    0     0  40500      0 --:--:-- --:--:-- --:--:-- 40500
   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                  Dload  Upload   Total   Spent    Left  Speed
   100    81  100    81    0     0  40500      0 --:--:-- --:--:-- --:--:-- 40500
   You've hit cole-serverapp-dep-69b9b4ddcd-wbdj2. Another very interesting message.
   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                  Dload  Upload   Total   Spent    Left  Speed
   100    81  100    81    0     0  40500      0 --:--:-- --:--:-- --:--:-- 40500
   You've hit cole-serverapp-dep-69b9b4ddcd-zl9m5. Another very interesting message.
   ...
   ```

   There may be some switch back between the messages as the pods from the
   previous versions are drained. If you run `kubectl get pods` again the output
   should be similar to the following:

   ```
   NAME                                  READY   STATUS    RESTARTS   AGE
   cole-serverapp-dep-69b9b4ddcd-rq59r   1/1     Running   0          39s
   cole-serverapp-dep-69b9b4ddcd-wbdj2   1/1     Running   0          36s
   cole-serverapp-dep-69b9b4ddcd-zl9m5   1/1     Running   0          34s
   cole-ubuntucurl                       1/1     Running   0          56m
   ```

   If you run `kubectl get deployments -o wide` you should see that the image of
   the pods is now `192.168.33.10:5000/cole-serverapp:v2.0.0`.

   ```
   NAME                 READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS       IMAGES                                     SELECTOR
   cole-serverapp-dep   3/3     3            3           64m   cole-serverapp   192.168.33.10:5000/cole-serverapp:v2.0.0   app=cole-serverapp
   ```
