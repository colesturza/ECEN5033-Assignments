# Assignment 2

Assignment 2 for ECEN5033 DevOps in the Cloud.

## How to run this assignment?

### Prerequisites:
For this assignment you will need to install vagrant. Follow the instructions provided [here](https://www.vagrantup.com/downloads).
You will also need VirtualBox (or another VM provider supported by vagrant).

### Commands:
To run the assignment simply clone this repo and from within the `assignment_2` directory run the following command.

```
$ vagrant up
```

Vagrant may need to install the docker plugin, in the event that that happens you may need to rerun the previous command again. Following the
completion the previous command, ssh into the default VM using the command below.

```
$ vagrant ssh default
```

Now run the following command once inside the VM.

```
$ docker-compose up
```

The client app will send a get request to the server app 10 times. The client app prints the response message from each request.

The message used by the server app is set via an environmental variable in the `docker-compose.yaml` file.  
