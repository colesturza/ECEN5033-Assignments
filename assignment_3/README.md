# Assignment 3

Assignment 3 for ECEN5033 DevOps in the Cloud.

## How to run this assignment?

### Prerequisites:
For this assignment you will need to install vagrant. Follow the instructions provided 
[here](https://www.vagrantup.com/downloads). You will also need VirtualBox (or another VM provider 
supported by vagrant).

### Commands:
To run the assignment simply clone this repo and from within the `assignment_3` directory run the following commands.

```shell
vagrant up
```

```shell
vagrant ssh
```

This will initialize the environment (etcd, registrator, and nginx).
```shell
bash start.sh
```

Then upgrade to the version 1 server app.
```shell
bash upgrade.sh server_v1.0.0
```

The following should output "A very interesting message."
```shell
curl "192.168.33.10:80" -w "\n"
```

Upgrade to version 2.
```shell
bash upgrade.sh server_v2.0.0
```

The following should output "Another very interesting message."
```shell
curl "192.168.33.10:80" -w "\n"
```

Upgrade to version 3.
```shell
bash upgrade.sh server_v3.0.0
```

The following should output "A 3rd very interesting message."
```shell
curl "192.168.33.10:80" -w "\n"
```

### Deploying/Upgrading with Multiple Containers:
The `upgrade.sh` script also allows for multiple containers to be deployed. Any number of the previous color containers will
be stopped as a result. The command to deploy 5 containers of version 1 is below.
```shell
bash upgrade.sh server_v1.0.0 5
```