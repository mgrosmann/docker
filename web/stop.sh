for id in $(docker ps -q -f status=running); do
  docker stop "$id"
done

