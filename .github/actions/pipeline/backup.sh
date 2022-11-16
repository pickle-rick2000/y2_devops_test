#!/bin/bash

 apt update
 apt install -y docker docker.io git


# docker login -u "jhonyvsn1992" -p "Bmwz3199719!"

# docker build -t jhonyvsn1992/yad2-go:${GITHUB_REF##*/}-${GITHUB_SHA} .
# docker push jhonyvsn1992/yad2-go:${GITHUB_REF##*/}-${GITHUB_SHA}

git config --global --add safe.directory /github/workspace
git config --global user.email "jhonatansela1@gmail.com"
git config --global user.name "jhony"

git clone https://github.com/pickle-rick2000/y2_devops_test.git
cd yad2_devops_test

$var=${GITHUB_REF##*/}-${GITHUB_SHA}
sed -i 's/image = "jhonyvsn1992\/yad2-go:.*"/image = "jhonyvsn1992\/yad2-go:${var}"/g' kube.tf

git add .
git commit -m "this is a commit from pipeline ${GITHUB_SHA}"
git push
