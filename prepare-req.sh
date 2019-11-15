#!/bin/sh

echo "Install important packages ..."
sudo apt-get install libgmp10 ca-certificates valgrind libc6-dev libgmp-dev cmake time patch ninja-build make autoconf automake libtool golang-go python subversion re2c git gcc g++ libredis-perl

echo "Install redis ..."
redis_repo=https://github.com/antirez/redis
redis_branch=5.0.3
redis_srcdir=$(pwd)/scratch/tools/redis

git clone $redis_repo $redis_srcdir
cd $redis_srcdir
git checkout $redis_branch
export CC=cc CXX=c++
make -j

export PATH=$redis_srcdir/src:$PATH
