#!/bin/bash

 apt update
 apt install -y docker docker.io git


docker login -u "jhonyvsn1992" -p "Bmwz3199719!"

docker build -t jhonyvsn1992/yad2-go:${GITHUB_REF##*/}-${GITHUB_SHA} .
docker push jhonyvsn1992/yad2-go:${GITHUB_REF##*/}-${GITHUB_SHA}



