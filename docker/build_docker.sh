#!/bin/sh -ex

# docker system prune -a

tar cz Dockerfile precision/souper precision/test performance/souper performance/llvm-with-calls-to-souper performance/test soundness/souper soundness/test | docker build -t artifact-cgo -

docker tag artifact-cgo jubitaneja/artifact-cgo
