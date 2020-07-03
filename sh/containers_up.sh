#!/bin/bash -Eeu

readonly ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# - - - - - - - - - - - - - - - - - - - - - -
ip_address_slow()
{
  if [ -n "${DOCKER_MACHINE_NAME:-}" ]; then
    docker-machine ip ${DOCKER_MACHINE_NAME}
  else
    echo localhost
  fi
}
readonly IP_ADDRESS=$(ip_address_slow)

# - - - - - - - - - - - - - - - - - - - - - -
wait_briefly_until_ready()
{
  local -r name="${1}"
  local -r port="${2}"
  local -r max_tries=20
  printf "Waiting until ${name} is ready"
  for _ in $(seq ${max_tries})
  do
    if ready ${port}; then
      echo .OK
      return
    else
      printf '.'
      sleep 0.1
    fi
  done
  echo FAIL
  echo "${name} not ready after ${max_tries} tries"
  if [ -f "$(ready_response_filename)" ]; then
    echo "$(ready_response)"
  fi
  docker logs ${name}
  exit 42
}

# - - - - - - - - - - - - - - - - - - -
ready()
{
  local -r port="${1}"
  local -r path=ready?
  local -r ready_cmd="\
    curl \
      --output $(ready_response_filename) \
      --silent \
      --fail \
      -X GET http://${IP_ADDRESS}:${port}/${path}"
  rm -f "$(ready_response_filename)"
  if ${ready_cmd} && [ "$(ready_response)" == '{"ready?":true}' ]; then
    true
  else
    false
  fi
}

# - - - - - - - - - - - - - - - - - - -
ready_response()
{
  cat "$(ready_response_filename)"
}

# - - - - - - - - - - - - - - - - - - -
ready_response_filename()
{
  printf /tmp/curl-puller-ready-output
}

# - - - - - - - - - - - - - - - - - - -
strip_known_warning()
{
  local -r docker_log="${1}"
  local -r known_warning="${2}"
  local stripped=$(echo -n "${docker_log}" | grep --invert-match -E "${known_warning}")
  if [ "${docker_log}" != "${stripped}" ]; then
    stderr "SERVICE START-UP WARNING: ${known_warning}"
  else
    stderr "WARNING NOT FOUND: ${known_warning}"
  fi
  echo "${stripped}"
}

# - - - - - - - - - - - - - - - - - - -
stderr()
{
  >&2 echo "${1}"
}

# - - - - - - - - - - - - - - - - - - -
fail_if_unclean()
{
  local -r name="${1}"
  local server_log=$(docker logs "${name}" 2>&1)

  #local -r mismatched_indent_warning="application(.*): warning: mismatched indentations at 'rescue' with 'begin'"
  #server_log=$(strip_known_warning "${server_log}" "${mismatched_indent_warning}")

  local -r line_count=$(echo -n "${server_log}" | grep --count '^')
  printf "Checking ${name} started cleanly..."
  # 3 lines on Thin (Unicorn=6, Puma=6)
  # Thin web server (v1.7.2 codename Bachmanity)
  # Maximum connections set to 1024
  # Listening on 0.0.0.0:4568, CTRL+C to stop
  if [ "${line_count}" == '6' ]; then
    echo OK
  else
    echo FAIL
    echo_docker_log "${name}" "${server_log}"
    exit 42
  fi
}

# - - - - - - - - - - - - - - - - - - -
echo_docker_log()
{
  local -r name="${1}"
  local -r docker_log="${2}"
  echo "[docker logs ${name}]"
  echo "<docker_log>"
  echo "${docker_log}"
  echo "</docker_log>"
}

# - - - - - - - - - - - - - - - - - - -
container_up_ready_and_clean()
{
  local -r port="${1}"
  local -r service_name="${2}"
  local -r container_name="test-${service_name}"
  container_up "${service_name}"
  wait_briefly_until_ready "${container_name}" "${port}"
  fail_if_unclean "${container_name}"
}

# - - - - - - - - - - - - - - - - - - -
container_up()
{
  local -r service_name="${1}"
  echo
  docker-compose \
    --file "${ROOT_DIR}/docker-compose.yml" \
    up \
    --detach \
    --force-recreate \
    "${service_name}"
}

# - - - - - - - - - - - - - - - - - - -
export NO_PROMETHEUS=true

container_up_ready_and_clean "${CYBER_DOJO_PULLER_PORT}"        puller
container_up_ready_and_clean "${CYBER_DOJO_PULLER_CLIENT_PORT}" runner
