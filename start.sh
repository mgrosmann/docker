#!/bin/bash
for file in *.yaml
do
  docker compose -f $file start ;
done
docker ps -a -q | xargs -r docker start
