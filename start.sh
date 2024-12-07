#!/bin/bash
for file in *.yaml
do
  docker compose -f $file start ;
done
docker ps -q | xargs -r docker start