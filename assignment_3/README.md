# Assignment 3

Assignment 3 for ECEN5033 DevOps in the Cloud.

## How to run this assignment?

### Prerequisites:
For this assignment you will need to install vagrant. Follow the instructions provided [here](https://www.vagrantup.com/downloads).
You will also need VirtualBox (or another VM provider supported by vagrant).

### Commands:
To run the assignment simply clone this repo and from within the `assignment_3` directory run the following commands.

```
$ vagrant up
```

```
$ vagrant ssh default
```

This will initialize the environment (etcd, confd, registrator, nginx). Then
create the v1.0.0 server app.
```
$ python3 upgrade.py -i v1.0.0
```

The following should output "A very interesting message."
```
$ curl "192.168.33.10:80" -w "\n"
```

Upgrade to version 2.
```
$ python3 upgrade.py v2.0.0
```

The following should output "Another very interesting message."
```
$ curl "192.168.33.10:80" -w "\n"
```

Upgrade to version 3.
```
$ python3 upgrade.py v3.0.0
```

The following should output "A 3rd very interesting message."
```
$ curl "192.168.33.10:80" -w "\n"
```
