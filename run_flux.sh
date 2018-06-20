#!/bin/sh

set -x

# Every 8 hours regenerate the docker creds and then kill fluxd so it picks them up
# Ghetto, but I don't want to do an upstream PR in the middle of this spike.
# The PR that I would make would have an API endpoint we can call to get the
# process to re-read the docker creds file, by accessing over :3030 in the pod.
while true; do
  make_docker_config_json.sh
  fluxd "$@" &
  fluxd_pid=$!
  sleep 28800
  kill -2 $fluxd_pid
  wait $fluxd_pid
done
