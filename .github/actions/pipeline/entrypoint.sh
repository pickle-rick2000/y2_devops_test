#!/bin/bash

echo "Hello from brnach: ${GITHUB_REF##*/}"


name: Build Docker Image For Go

on:
  push:
    branches: [ "master" ]


jobs:

  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - name: Build the Docker image
      run: docker build . --file ../../Dockerfile --tag jhonyvsn1992/yad2-go:${GITHUB_REF##*/}-${GITHUB_SHA}
