#!/bin/bash -Eeu

versioner_env_vars()
{
  docker run --rm cyberdojo/versioner
  echo CYBER_DOJO_PULLER_CLIENT_PORT=4597 # runner
  echo CYBER_DOJO_PULLER_CLIENT_USER=nobody
  echo CYBER_DOJO_PULLER_SERVER_USER=nobody
}
