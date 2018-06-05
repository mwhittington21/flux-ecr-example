#!/bin/bash

TAG=struz/ecr-creds
VERSION=v0.2.8

docker build . -t "${TAG}:${VERSION}"
if [[ "$#" -gt 0 && "$1" == "push" ]]; then docker push "${TAG}:${VERSION}"; fi
