#!/bin/bash
stopped_containers=$(docker ps -a -f "status=exited" -q)
  docker rm $stopped_containers
