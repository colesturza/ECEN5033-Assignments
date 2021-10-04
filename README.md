# ECEN5033-Assignments

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
