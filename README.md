# ECEN5033 DevOps in the Cloud Assignments 

## Assignemnt 1
**Part 1:**
Create a vagrant file to 1) create two virtual machines, 2) On one of them, install ansible, 3) on one of them create an ssh key pair and install it on the other (using Option 2 - copying over via ssh, rather than via the filesystem).

**Part 2:**
Create an ansible playbook which builds some application from source -- that is, from a base VM image (e.g., ubunty/trusty64), you run 1 ansible playbook to get any packages, get the source, etc. to build the application.

## Assignemnt 2
**Part 1:**
Create a client and server application (any language).  

**Client**
  - Periodically makes a GET request to the server.
  - Period and IP address of server to be set via Environment variables (in part 2, this can be set via the Dockerfile, --env in the docker run command, or in the docker-compose yaml)

**Server**
  - Responds with a message
  - Message to be set via Environment variable (in part 2, this can be set via the dockerfile, --env in the docker run command, or in the docker-compose yaml)

**Part 2:**
Create Dockerfile's for each of the client and server. Create a docker-compose file that describes both containers - for this assignment, client and server can run on the same server.

## Assignemnt 3
Blue/Green zero downtime update.

**Requirement:**
* Server App: returns some hard coded string. Modify that string, rebuild the container, perform an upgrade
Can do this on 1 VM. Can assume requests are short (nginx workers end immediately). Can skip running tests on v{N+1} before switching.

**Note:**
* Simplifying assumptions are fine, within reason.  e.g., the upgrade script only works for a specific service (and isn't general to any service) - that's fine.
* All IP addresses/ports should be selected automatically by Docker.

## Assignment 4
In HW2, you created two docker containers – a client which continuously makes requests to a server which will respond with some message.  In HW3 you enabled upgrading the server (with a new message). In HW4, you'll expand this to run in Kubernetes, with some modifications - namely, the server returns it's own hostname and some hard coded message.
Note: njsapp that I provided includes the hostname, so you just need to extend that a bit.

**Part 1:**
Server must: 1) be able to scale out, 2) tolerate failure. Use ReplicationController and a Service.  
  - Server instances must run on machine2 (need nodeSelector)
  - Client must run on machine3 (need nodeSelector)

**Part 2:**
Now, support upgrades. Without bringing down the server.

Easiest way will be create a deployment (which will launch new Pods), then delete the Replication controller. You could also delete the Replication controller without deleting the Pods (recall `kubectl delete rc <name> --cascade=false` won't delete the pods), then launch a Deployment.

https://upendra-kumarage.medium.com/kubernetes-replicationcontrollers-deployments-and-update-existing-replicationcontroller-to-3b0ecf0bf349

Then, demonstrate an upgrade by changing the message of the server.
