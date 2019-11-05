This repository guides you to build and test
our work we submitted to CGO 2020.

This detailed guide will help you setup a
testing environment to evaluate Sections 4.1
to 4.5.

- We have also provided the docker image to
save a lot of building/testing time as our
experiments shown in Table 1 take ~40 hours
to test precision of each dataflow fact
on SPEC CPU 2017 benchmark.

- The results shown in Table 2 takes around
an hour to 70 hours to build different
applications for performance testing.

- The results shown in Section 4.2 to 4.5
can be tested quickly once you have
build Souper and LLVM+Clang-8.0.

# Requirements

Souper should run on a modern Linux or OSX machine.
The requirements for different tools and compiler
are ass follows:

### Z3
  To run Souper over a bitcode file, you will need an SMT
  solver. Our work has used Z3 solver version 4.8.6. 
  You can download the source from
  [here](https://github.com/Z3Prover/z3/releases/tag/z3-4.8.6).
  Follow the instructions in
  [README file](https://github.com/Z3Prover/z3#building-z3-using-make-and-gccclang)
  to build Z3.

### Clang
  You will need a modern toolchain for building Souper. LLVM
  has instructions on how to get one for Linux
  [here](http://llvm.org/docs/GettingStarted.html#getting-a-modern-host-c-toolchain).
  Our work used clang-7.0.1 to build Souper.

### Re2c
  In case your machine does not have re2c package
  installed, you can download the source from
  [here](https://github.com/skvadrik/re2c/releases/tag/1.0.1).
  Our work used re2c version: 1.0.1.
  Follow the instructions in [README file](https://github.com/skvadrik/re2c#build)
  to configure and build re2c.

### Redis
  Our work requires caching the Souper queries results using Redis.
  We used redis version >= 4.0.9 for our work. You can download
  the source code [here](https://redis.io/download). Follow the
  instructions to build [here](https://redis.io/download#installation). 

### CMake
  You need CMake to build Souper and its dependencies. Our work
  used cmake version 3.10.2. If you want to build CMake
  from source, you can download the source [here](https://cmake.org/download/).
  Follow the instructions in README.txt file to build.


# Building Souper

Follow the steps:

```
$ cd $HOME
$ git clone https://github.com/jubitaneja/souper.git
$ cd $HOME/souper
$ git checkout cgo
$ ./build_deps.sh
$ mkdir $HOME/souper/build && cd $HOME/souper/build
$ cmake .. -G Ninja
$ ninja
```

You can find the compiled *souper* binary in `$HOME/souper/build` directory,
and *clang* binary in `$HOME/souper/third_party/llvm/Release/bin/` directory.

# Evaluation: Section 4.1

Follow the instructions
[here](https://github.com/jubitaneja/artifact-cgo/tree/master/section-4.1).

# Evaluation: Section 4.2 to Section 4.5

Run the script [here](https://github.com/jubitaneja/artifact-cgo/blob/master/run.sh).

# Evaluation: Section 4.6


