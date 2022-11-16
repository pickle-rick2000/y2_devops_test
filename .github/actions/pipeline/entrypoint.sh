#!/bin/bash

echo "Hello from brnach: ${GITHUB_REF##*/}"

 apt update
 apt install -y docker docker.io

docker login -u ${DOCKER_USERNAME} -p {DOCKER_PASSWORD}
docker build -t jhonyvsn1992/yad2-go:${GITHUB_REF##*/}-${GITHUB_SHA} .
docker push jhonyvsn1992/yad2-go:${GITHUB_REF##*/}-${GITHUB_SHA}