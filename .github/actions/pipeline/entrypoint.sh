#!/bin/bash

echo "Hello from brnach: ${GITHUB_REF##*/}"

apt update
apt install -y docker docker.io

docker build . --file ../../Dockerfile --tag jhonyvsn1992/yad2-go:${GITHUB_REF##*/}-${GITHUB_SHA}