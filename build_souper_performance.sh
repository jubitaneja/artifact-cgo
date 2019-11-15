#!/bin/bash

# dependencies: subversion cmake ninja-build re2c

mkdir $(pwd)/scratch/performance
cd $(pwd)/scratch/performance

# Building Souper

git clone https://github.com/zhengyangl/souper
cd souper && git checkout artifact
./build_deps.sh

mkdir build
cd build

export SOUPER_BUILD=`pwd` # it seems cmake only accepts abs path

cmake .. -G Ninja 
ninja 

cd ../..


# Building LLVM
git clone https://github.com/zhengyangl/llvm-with-calls-to-souper.git
cd llvm-with-calls-to-souper && git checkout artifact
cd ..
mkdir build
cd build 



cmake ../llvm-with-calls-to-souper -G Ninja -DLLVM_FORCE_ENABLE_STATS=On -DCMAKE_BUILD_TYPE=Release -DSOUPER_INCLUDE="$SOUPER_BUILD/../include" -DCLANG_ANALYZER_ENABLE_Z3_SOLVER=Off -DSOUPER_LIBRARIES="$SOUPER_BUILD/libsouperExtractor.a;$SOUPER_BUILD/libsouperInst.a;$SOUPER_BUILD/libkleeExpr.a;$SOUPER_BUILD/libsouperKVStore.a;$SOUPER_BUILD/libsouperInfer.a;$SOUPER_BUILD/libsouperClangTool.a;$SOUPER_BUILD/libsouperSMTLIB2.a;$SOUPER_BUILD/libsouperParser.a;$SOUPER_BUILD/libsouperTool.a;$SOUPER_BUILD/../third_party/alive2/build/libalive2.so;$SOUPER_BUILD/../third_party/hiredis/install/lib/libhiredis.a" 


ninja

cd ..
git clone https://github.com/zhengyangl/llvm-with-calls-to-souper.git llvm-baseline
cd llvm-baseline
git checkout baseline
cd ..

mkdir build-baseline
cd build-baseline

cmake ../llvm-baseline -G Ninja -DLLVM_FORCE_ENABLE_STATS=On -DCLANG_ANALYZER_ENABLE_Z3_SOLVER=Off -DCMAKE_BUILD_TYPE=Release

ninja

cd ..

