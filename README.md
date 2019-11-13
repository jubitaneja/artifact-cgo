This repository guides you to build and test
our work that we submitted to **CGO 2020**.

There are two ways you can reproduce the results.
- Following the instructions to use a pre-compiled [docker image](https://github.com/jubitaneja/artifact-cgo#using-docker-image).
- Following the instructions to [build from scratch](https://github.com/jubitaneja/artifact-cgo#building-from-scratch).

For your reference, we want to inform you that all our work
is open source. You can build it easily with some assumptions
on pre-requisites listed further. The results shown
in Table 1 and 2 (in paper) are time consuming.

To give you an idea on evaluation time, for testing SPEC
CPU 2017 benchmark for precision testing experiment, it
takes ~10 hours to ~40 hours on a machine with two
28-core Xeon processors.

The performance evaluation experiment requires building
applications like, Gzip, Bzip2, Stockfish, and SQLite.
It takes from a couple of hours for Bzip2 to
~70 hours for SQLite.

**In case, you have any time constraints, we recommend
you to pull the docker image especially for performance
evaluation experiment.**

# Using Docker Image

## Requirements
Souper should run on a modern Linux or OSX machine.
We tested our work on Ubuntu-18.04 version. Check
Ubuntu version:
```
$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 18.04.3 LTS
Release:        18.04
Codename:       bionic
```

### Docker
Install docker engine by following the instructions
[here](https://docs.docker.com/install/linux/docker-ce/ubuntu/).

### SPEC CPU Benchmark 2017
Our evaluation involves [SPEC CPU 2017](https://www.spec.org/cpu2017/)
benchmark. We cannot provide a copy of this benchmark as restricted
by the SPEC License Agreement. For details, check
[this](https://www.spec.org/cpu2017/docs/licenses.html).

For Table 1 in paper, we assume you have SPEC ISO image, version 1.0.1.

### Steps to follow
1. Fetch the docker image from docker hub.
```
$ docker pull jubitaneja/artifact-cgo:latest
```
To check the list of images, run:
```
$ docker images
REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
jubitaneja/artifact-cgo   latest              d5bc1be66342        2 hours ago         14.2GB
```

2. Run the docker image.
```
$ docker run -it jubitaneja/artifact-cgo /bin/bash
```
This command will load and run the docker image, and `-it`
option attaches you an interactive tty container.

3. Evaluate the experiments.

# Building from scratch


## Requirements

Souper should run on a modern Linux or OSX machine.
The requirements for different tools and compiler
are ass follows:

### Z3
  To run Souper over a bitcode file, you will need an SMT
  solver. Our work has used Z3 solver version 4.8.6. 
  ```
  $ z3 --version
  Z3 version 4.8.6 - 64 bit
  ```
  You can download the source from
  [here](https://github.com/Z3Prover/z3/releases/tag/z3-4.8.6).
  Follow the instructions in
  [README file](https://github.com/Z3Prover/z3#building-z3-using-make-and-gccclang)
  to build Z3.

  *Tip:* Make sure to export Z3 binary path in `PATH` environment variable.
  ```
  export PATH=/path/to/z3:$PATH
  ```

### Clang
  You will need a modern toolchain for building Souper. LLVM
  has instructions on how to get one for Linux
  [here](http://llvm.org/docs/GettingStarted.html#getting-a-modern-host-c-toolchain).
  Our work used clang-7.0.1 to build Souper.

  ```
  $ clang --version
  clang version 7.0.1
  ```

### Re2c
  In case your machine does not have re2c package
  installed, you can download the source from
  [here](https://github.com/skvadrik/re2c/releases/tag/1.0.1).
  Our work used re2c version: 1.0.1.
  ```
  $ re2c --version
  re2c 1.0.1
  ```
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
  ```
  $ cmake --version
  cmake version 3.10.2
  ```
*Tip:* Make sure to export Z3, clang, cmake, redis, re2c binaries path
in `PATH` environment variable.
```
$ export PATH=/path/to/z3:/path/to/cmake:/path/to/re2c:/path/to/redis-server:/path/to/clang:%PATH
```

## Building Souper

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

## Evaluation: Section 4.1

Follow the instructions
[here](https://github.com/jubitaneja/artifact-cgo/tree/master/section-4.1).

## Evaluation: Section 4.2 to Section 4.5

Run the script [here](https://github.com/jubitaneja/artifact-cgo/blob/master/run.sh).

## Evaluation: Section 4.6


