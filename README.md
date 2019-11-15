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

# Approach 1: Using Docker Image

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
$ sudo docker pull jubitaneja/artifact-cgo:latest
```
To check the list of images, run:
```
$ sudo docker images
REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
jubitaneja/artifact-cgo   latest              d5bc1be66342        2 hours ago         14.2GB
```

2. Run the docker image.
```
$ sudo docker run -it jubitaneja/artifact-cgo /bin/bash
```
This command will load and run the docker image, and `-it`
option attaches you an interactive tty container.

3. Evaluate the experiments.
After you have successfully run the docker image, you can
go the path:
```
$ cd /usr/src/artifact-cgo
```
This directory contains the entire setup of our tool.

### Evaluation: Section 4.1
This section makes use of SPEC CPU 2017 benchmark
that we cannot share directly in the docker image.
For this, you will need your own ISO image and follow
the instructions [here](https://github.com/jubitaneja/artifact-cgo#evaluation-section-41-1)
to reproduce the results.

### Evaluation: Section 4.2 to 4.5
These sections evaluates the precision of several
dataflow analyses as shown in examples in the paper.
Runt the script to reproduce the results.
```
$ cd /usr/src/artifact-cgo/precision/test
$ ./run.sh
```

#### Understanding the results

### Evaluation: Section 4.6
This section measures the impact of precision
of dataflow analysis. We test compression
applications, like Bzip2, bzip; SQLite;
and a chess engine, Stockfish as shown
presented in Table 2 in paper.

**NOTE:** In paper, to test the performance of gzip and bzip2,
we compressed the 2.9 GB ISO image for SPEC CPU 2017,
and decompressed the resulting compressed file.
However, for the artifact evaluation purpose
we cannot distribute SPEC ISO image. We modified
this experiment setting by generating a random
1GB file using `dd` utility.

Run the script to reproduce the results for all applications.
```
$ cd /usr/src/artifact-cgo/performance/test
$ ./main.sh
```

#### Understanding the results
The results are saved in:
- bzip2: result-bzip2.txt
- gzip: result-gzip.txt
- stockfish: result-stockfish.txt
- sqlite: result-sqlite.txt

The speedup numbers may vary depending on which
architecture you are using, and what is the configuration
of the processor.

### Evaluation: Section 4.7
This section evaluates three soundness bugs
as discussed in the paper. Run the script:
```
$ cd /usr/src/artifact-cgo/soundness/test
$ ./sound-test.sh
```

### Evaluation: Section 4.8
This section mentioned that our work contributed
towards making concrete improvements to LLVM.
We provide references to each one of those
here.

- Evaluating `x & (x-1)` results in a value that always
  has the bottom bit cleared [[Ref:1]](https://reviews.llvm.org/rL252629).

- The LLVM byte-swap intrinsic function was not handled by
  known bits analysis earlier. It is fixed now [[Ref:2]](https://reviews.llvm.org/D13250).

- `0 - zext(x)` is always negative [[Ref:3]](https://reviews.llvm.org/D3754).

- The result of `@llvm.ctpop` countpop intrinsic had room for improvement
  [[Ref:4]](https://reviews.llvm.org/D13253).

- Test for equality can be resolved at compile time sometimes using dataflow
  analysis [[Ref:5]](https://reviews.llvm.org/D3868).


#### Understanding the results

# Approach 2: Building from scratch


## Requirements

Souper should run on a modern Linux or OSX machine.
We used Ubuntu-18.04 for our work. Check Ubuntu version:
```
$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 18.04.3 LTS
Release:        18.04
Codename:       bionic
```

There are certain requirements for different
tools and compiler. For this, you can either run the
`prepare-req.sh` script or follow the instructions
for each pre-requisite separately.

### Approach 1: Use script

The script requires `sudo` access to
install some packages from `apt-get` package
manager.
```
$ git clone https://github.com/jubitaneja/artifact-cgo.git && cd artifact-cgo
$ export CGO_HOME=$(pwd)
$ ./prepare-req.sh
```
### Approach 2: Build manually

Follow the initial steps, and start building the tools:
```
$ git clone https://github.com/jubitaneja/artifact-cgo.git && cd artifact-cgo
$ export CGO_HOME=${PWD}
$ mkdir -p ${CGO_HOME}/scratch/tools
$ cd ${CGO_HOME}/scratch/tools
```
- **Requirement 1: Re2c**

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

- **Requirement 2: Redis**

  Our work requires caching the Souper queries results using Redis.
  We used redis version 5.0.3  for our work. You can download
  the source code [here](https://redis.io/download). Follow the
  instructions to build [here](https://redis.io/download#installation). 

- **Requirement 3: CMake**

  You need CMake to build Souper and its dependencies. Our work
  used cmake version 3.10.2. If you want to build CMake
  from source, you can download the source [here](https://cmake.org/download/).
  Follow the instructions in README.txt file to build.
  ```
  $ cmake --version
  cmake version 3.10.2
  ```
- *Tip:* Make sure to export clang, cmake, redis, re2c binaries path
 in `PATH` environment variable.

## Building Souper

After all pre-requisties have been installed,
follow the steps to build Souper for precision testing
experiment.

```
$ cd ${CGO_HOME}
$ ./build_souper_precision.sh
```

You can find the compiled **`souper`** binary in `$CGO_HOME/scratch/precision/souper/build` directory,
and **`clang`** binary in `$CGO_HOME/scratch/precision/souper/third_party/llvm/Release/bin/` directory.

## Evaluation: Section 4.1

Follow the instructions
[here](https://github.com/jubitaneja/artifact-cgo/tree/master/section-4.1).

## Evaluation: Section 4.2 to Section 4.5

Run the script `test_precision.sh`
```
$ cd ${CGO_HOME}
$ ./test_precision.sh
```
#### Understanding the results

## Evaluation: Section 4.6
Follow the instructions [here](https://github.com/jubitaneja/artifact-cgo/tree/master/section-4.6).

## Evaluation: Section 4.7

Build souper to reproduce soundness bugs, and then
run the `test_sound.sh` script to test bugs.
```
$ cd ${CGO_HOME}
$ ./build_souper_sound.sh
$ ./test_sound.sh
```

#### Understanding the results

# Customization: How to use our tool for extended testing?

