for id in $(docker ps -a -q -f status=exited); do
  docker start "$id"
done

