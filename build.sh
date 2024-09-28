#! /bin/bash
# shellcheck disable=SC2034

DOCKER_REPO="${DOCKER_REPO:-moonbuggy2000/tinyfilemanager}"

all_tags='latest'
default_tag='latest'

TARGET_VERSION_TYPE='major'

custom_source_versions() {
  git_repo_tags "${TFM_REPO}"
}

custom_updateable_tags() {
  # shellcheck disable=SC2154
  echo "${source_latest}"
}

. "hooks/.build.sh"
