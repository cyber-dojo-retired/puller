#!/bin/bash -Eeu

readonly ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

echo
docker-compose \
  --file "${ROOT_DIR}/docker-compose.yml" \
  stop

echo
docker logs test-runner 2>&1 | grep "Goodbye from puller client"
docker logs test-puller 2>&1 | grep "Goodbye from puller server"
echo

docker-compose \
  --file "${ROOT_DIR}/docker-compose.yml" \
  down \
  --remove-orphans \
  --volumes
