#! /usr/bin/with-contenv /bin/sh
# shellcheck shell=sh

CONFIG_FILE='/var/www/html/config.php'

env | grep ^TFM_ | while read kv; do
  key="${kv%%=*}"
  key="$(echo ${key#*_} | tr '[:upper:]' '[:lower:]')"

  value="${kv#*=}"

  if grep -q "\$${key}" "${CONFIG_FILE}"; then
    echo "tfm-init: info: set ${key} = ${value}"
    sed -E "s|^(\\\$${key}\s?=\s?).*;|\1${value};|" -i "${CONFIG_FILE}"
  else
    echo "tfm-init: WARNING: no matching key: cannot set ${key} = ${value}"
  fi
done
