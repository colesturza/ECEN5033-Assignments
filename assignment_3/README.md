# Assignment 3

Assignment 3 for ECEN5033 DevOps in the Cloud.

## How to run this assignment?

### Prerequisites:
For this assignment you will need to install vagrant. Follow the instructions provided [here](https://www.vagrantup.com/downloads).
You will also need VirtualBox (or another VM provider supported by vagrant).

### Commands:
To run the assignment simply clone this repo and from within the `assignment_3` directory run the following commands.

```shell
vagrant up
```

```shell
vagrant ssh
```

This will initialize the environment (etcd, confd, registrator, nginx). Then
create the v1.0.0 server app.
```shell
bash upgrade server_v1.0.0
```

The following should output "A very interesting message."
```shell
curl "192.168.33.10:80" -w "\n"
```

Upgrade to version 2.
```shell
bash upgrade server_v2.0.0
```

The following should output "Another very interesting message."
```shell
curl "192.168.33.10:80" -w "\n"
```

Upgrade to version 3.
```shell
bash upgrade server_v3.0.0
```

The following should output "A 3rd very interesting message."
```shell
curl "192.168.33.10:80" -w "\n"
```
