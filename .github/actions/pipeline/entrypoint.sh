#!/bin/bash

echo "Hello from brnach: ${GITHUB_REF##*/}"

ls -l
pwd
cat Dockerfile

# apt update
# apt install -y docker docker.io

# docker build . --tag jhonyvsn1992/yad2-go:${GITHUB_REF##*/}-${GITHUB_SHA}