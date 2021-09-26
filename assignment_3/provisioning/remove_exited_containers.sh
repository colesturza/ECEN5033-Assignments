#!/bin/bash

sudo docker rm $(docker ps --filter status=exited -q)
