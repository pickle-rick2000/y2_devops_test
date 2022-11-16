#!/bin/bash

#install docker
 apt update
 apt install -y docker docker.io

#login to docker
docker login -u "jhonyvsn1992" -p "Bmwz3199719!"

#build
docker build -t jhonyvsn1992/yad2-go:${GITHUB_REF##*/}-${GITHUB_SHA} .
docker build -t jhonyvsn1992/yad2-go:${GITHUB_REF##*/}-latest .

#test the image
docker run -d -p 8080:8080 jhonyvsn1992/yad2-go:${GITHUB_REF##*/}-latest
test_app=`curl http://yad2-go.app.com/posts`

if [$test_app -eq "post"]
then
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    docker push jhonyvsn1992/yad2-go:${GITHUB_REF##*/}-${GITHUB_SHA}
    docker push jhonyvsn1992/yad2-go:${GITHUB_REF##*/}-latest
else
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    echo "The app isnt running accordingly. Sorry, but you failed."
fi
