#!/bin/bash -Ee

readonly ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# - - - - - - - - - - - - - - - - - - - - - - - -
image_name()
{
  echo "${CYBER_DOJO_PULLER_IMAGE}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
sha()
{
  echo "$(cd "${ROOT_DIR}" && git rev-parse HEAD)"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
tag()
{
  local -r sha="$(sha)"
  echo "${sha:0:7}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
tag_image()
{
  docker tag "$(image_name):latest" "$(image_name):$(tag)"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
tag_image
