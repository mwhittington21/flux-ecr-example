#!/bin/bash

TAG=struz/ecr-flux
VERSION="v1.4.1-0"

docker build . -t "${TAG}:${VERSION}"
if [[ "$#" -gt 0 && "$1" == "push" ]]; then docker push "${TAG}:${VERSION}"; fi
