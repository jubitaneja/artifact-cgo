#!/bin/sh

echo "Building Souper ..."
souper_repo=https://github.com/jubitaneja/souper.git
souper_branch=soundness-bugs
souper_src_dir=$(pwd)/scratch/soundness/souper
souper_build_dir=$(pwd)/scratch/soundness/souper/build
build_type=Release

git clone $souper_repo $souper_src_dir
cd $souper_src_dir
git checkout $souper_branch
./build_deps.sh $build_type
mkdir -p $souper_build_dir
cd $souper_build_dir
cmake .. -G Ninja
ninja

