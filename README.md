This repository guides you to build and test
our work that we submitted to **CGO 2020**.

There are two ways you can reproduce the results.
- Following the instructions to use a pre-compiled [docker image](https://github.com/jubitaneja/artifact-cgo#approach-1-using-docker-image).
- Following the instructions to 
[build from scratch](https://github.com/jubitaneja/artifact-cgo#approach-2-building-from-scratch).

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
$ ./test_precision.sh
```

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
$ ./test_performance.sh
```

This will take about 40-50 minutes to finish. If you
want to understand what's happening, please refer the
details mentioned [further](https://github.com/jubitaneja/artifact-cgo#section-46).

### Evaluation: Section 4.7
This section evaluates three soundness bugs
as discussed in the paper. Run the script:
```
$ cd /usr/src/artifact-cgo/soundness/test
$ ./test_sound.sh
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
`prepare_req.sh` script or follow the instructions
for each pre-requisite separately.

### Approach 1: Use script

The script requires `sudo` access to
install some packages from `apt-get` package
manager.
```
$ git clone https://github.com/jubitaneja/artifact-cgo.git && cd artifact-cgo
$ export CGO_HOME=$(pwd)
$ ./prepare_req.sh
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

# Analyzing the results

## Section 4.1

The precision testing results are saved in individual
files for each analysis. For instance,

- Known bits analysis results in files:`knownbits_*`
- Negative analysis results in files: `neg_*`
- Non-negative analysis results in files: `nonneg_*`
- Non-zero analysis results in files: `nonzero_*`
- Power of two analysis results in files: `power_*`
- Number of sign bits analysis results in files: `signbits_*`
- Range analysis results in files: `range_*`
- Demanded bits results in files: `demandedbits_*`

Each individual file corresponds to a Souper
expression for which we computed dataflow facts
from our tool, Souper and LLVM compiler. So, you
will find a very large number of files generated
as a result.

Now, to reproduce the numbers as shown in Table 1
in the paper, you just have to run this 
[script](https://github.com/jubitaneja/artifact-cgo/blob/master/section-4.1/extra-scripts/process-all.sh).

```
# Go to the main directory of this repo.

$ export CGO_HOME=$(pwd)/artifact-cgo
$ cd $CGO_HOME
$ ./section-4.1/extra-scripts/process-all.sh
```

This script will give you the count of parameters like,
`Souper is more precise`, `LLVM is more precise`,
`Same precision`, `Resource exhaustion`.

You may find non-zero number of `llvm is stronger`
cases for some analyses. These should be manually
tested and analyzed further by increasing the
solver timeout value, increasing the maximum
tries for constant synthesis, not limiting
the execution time on Z3 and souper-check processes
through crontab, etc.

## Section 4.2

You are analyzing known bits computed by
our tool - Souper, and LLVM compiler.
The results should look like this. 

### Sample output
```
===========================================
 Evaluation: (Known bits) Section 4.2
===========================================
-------------------------------
 Test: /usr/src/artifact-cgo/precision/test/section-4.2/known1.opt
-------------------------------
%x:i8 = var
%0:i8 = shl 32:i8, %x
infer %0
knownBits from souper: xxx00000
knownBits from compiler: xxxxxxxx
; Listing valid replacements.
; Using solver: Z3 + internal cache
```

### Input

The first part is the input test written in
Souper IR.
```
%x:i8 = var
%0:i8 = shl 32:i8, %x
infer %0
```

This specifies a shift left operation of a 8-bit
constant value `32` by an unknown shift
amount labelled by `%x`. The question is to
compute known bits information for `%0` i.e.
`32 << %x` from both compiler and our tool - Souper.

### Workflow

- When computing facts by Souper - How it works?

Input (Souper IR) -> **`souper-check`** -> known bits from Souper

- When computing facts by LLVM compiler - how it works?

Input (Souper IR) -> **`souper2llvm`** -> LLVM IR (.ll file) -> **`llvm-as`** -> LLVM IR (.bc file) -> **`souper`** -> known bits from compiler

In the second pipeline, `souper` makes calls to LLVM's
dataflow functions to compute results from compiler.

### Dataflow information
The result is a 8-bit known bits information for shift-left
operation `(32 << %x)`. The `x` in the result indicates that
a bit is unknown, `0` means that a bit is known zero, `1`
means that a bit is known one.

Clearly, compiler computes `xxxxxxxx` which means all bits
are unknown. However, Souper computes `xxx00000` which means
our algorithm can prove 5-low bits as zero and is thus, more
precise than LLVM compiler.

Likewise, you can now analyze other examples included in the result.

## Section 4.3

You are analyzing the power of two dataflow
analysis results. The output should look like this.

### Sample output

```
===========================================
 Evaluation: (Power of two) Section 4.3
===========================================
-------------------------------
 Test: /usr/src/artifact-cgo/precision/test/section-4.3/power1.opt
-------------------------------
%x:i64 = var (range=[1,3))
infer %x
known powerOfTwo from souper: true
known powerOfTwo from compiler: false
; Listing valid replacements.
; Using solver: Z3 + internal cache
```

### Input
The first part is input written in Souper IR.
```
%x:i64 = var (range=[1,3))
infer %x
```
What does it mean? This is an input variable
of 64-bits with a given range [1,3) in which
lower bound `1` is included, but upper bound
`3` is excluded. In short, the input variable
labelled `%x` in above Souper IR is a number in
the set `{1, 2}`.

Now, we question if this is a power of two or not
from both Souper and LLVM compiler.

### Dataflow information

The result computed by compiler is `false` that means
LLVM compiler cannot prove that it input
variable with specified range is a power of two.
However, Souper returns the result `true` that is it
can prove that given input test is a power of two.

Now, you can analyze rest of the examples in this section.

## Section 4.4

You are analyzing demanded bits results in this section.
The output should look like this.
```
===========================================
 Evaluation: (Demanded bits) Section 4.4
===========================================
-------------------------------
 Test: /usr/src/artifact-cgo/precision/test/section-4.4/demanded1.opt
-------------------------------
%x:i8 = var
%0:i1 = slt %x, 0:i8
infer %0
demanded-bits from souper for %x : 10000000
demanded-bits from compiler for var_x : 11111111
; Listing valid replacements.
; Using solver: Z3 + internal cache
```

### Input

The input in this case is:
```
%x:i8 = var
%0:i1 = slt %x, 0:i8
infer %0
```

This specifies a signed less than (slt) operation to
check if 8-bit (i8) input variable `%x` is signed
less than `0`. The question is to compute demanded bits
for variable `%x` from both Souper and LLVM.

### Dataflow information
The representation of bits is same as known bits,
where `x` means unknown bit, `0` means a bit is not
demanded, and `1` means that a bit is demanded.

A bit is not demanded means the value of it won't
affect the result in any way, and the more we know
about such bits, the better it is to perform optimizations.
You can check details of this analysis in the paper.

Now, coming back to this example. LLVM computes
the result ``11111111` which means LLVM says that all
bits are demanded.
However, Souper using our SMT solver-based algorithms
computes the result `10000000` which means that
our algorithms can prove that only most significant
bit (MSB) is demanded, and all other bits in the result are
not demanded. This is because signed less than operation
with constant zero only cares about the MSB.
Hence, Souper computes precise fact than LLVM.

Likewise, you can now verify other examples in this section.

## Section 4.5

You are analyzing integer range analysis results in
this section. The outout should look like this.

### Sample Output
```
===========================================
 Evaluation: (Range) Section 4.5
===========================================
-------------------------------
 Test: /usr/src/artifact-cgo/precision/test/section-4.5/range1.opt
-------------------------------
%x:i8 = var
%0:i1 = eq 0:i8, %x
%1:i8 = select %0, 1:i8, %x
infer %1
known range from souper: [1,0)
known at return: [-1,-1)
; Listing valid replacements.
; Using solver: Z3 + internal cache
```

### Input

```
%x:i8 = var
%0:i1 = eq 0:i8, %x
%1:i8 = select %0, 1:i8, %x
infer %1
```

The select instruction is LLVM’s ternary
conditional expression, analogous to the `?:`
construct in C and C++. The expression below
returns one if %x is zero, and returns %x otherwise.

The goal is to compute the range for 8-bit
result (`%1`) computed by select operation.

### Dataflow information

LLVM cannot compute any precise result in this
case, and returns the default full-set represented
by `[-1, -1]` which means the range of numbers starting
at `-1` as lower bound, wrapping around and stopping
at upper bound `-1`.

However, Souper computes the result `[1, 0]` which
means it is a set of all numbers starting at `1`,
wrapping around but excluding `0`. Thus, Souper
can precisely compute the range and tell us that
the result will not be zero, but any other number.

Likewise, you can now analyze other examples in this
section.

## Section 4.6

In this section, you are analyzing the results
shown in Table 2 in the paper. When you will
run the specified scripts in Docker, the output
should look like this.

### Sample output Log on the console
This is how the output should look on the console.
You can ignore these messages, these are
just added to give you an idea about
what is happening. We iterate each experiment
for three times and compute the average speedup
at the end.

```
============================
   Performance Evaluation
============================

Preparing file ...
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 16.3392 s, 65.7 MB/s
Created a file: 1gb

***************************
Testing #1: bzip2
***************************

Iteration #1: computing baseline compression time

Iteration #1: computing precise compression time


Iteration #1: computing baseline decompression time

Iteration #1: computing precise compression time


Iteration #2: computing baseline compression time
...
```

```
***************************
Testing #2: gzip
***************************

Iteration #1: computing baseline compression time

Iteration #1: computing precise compression time


Iteration #1: computing baseline decompression time

Iteration #1: computing precise decompression time

...
```

```
***************************
Testing #3: Sqlite
***************************

Iteration #1: Baseline SQLite run


Iteration #1: Precise SQLite run


Iteration #2: Baseline SQLite run
```

```
***************************
Testing #4: stockfish
***************************

Iteration #1: Baseline stockfish run
Stockfish 10 64 POPCNT by T. Romstad, M. Costalba, J. Kiiski, G. Linscott
info depth 1 seldepth 1 multipv 1 score cp 116 nodes 20 nps 10000 tbhits 0 time 2 pv e2e4
info depth 2 seldepth 2 multipv 1 score cp 112 nodes 54 nps 27000 tbhits 0 time 2 pv e2e4 b7b6
...

```

### Final output on console
At the end, you will should see the
final results for each benchmark as
shown below.

#### Bzip2
For bzip2, you will find average compression/
decompression time for both baseline and precise version.
If you want to check individual result of
each iteration, you can check the file:
`result-bzip.txt` in Docker at path:
`/usr/src/artifact-cgo/performance/test/`
```
===================================
Final result of bzip2
===================================


Avg Baseline Compression time = 296.663333333 sec

Avg Precise Compression time = 242.42 sec



Speedup in compression time = 18.2844751065%
------------------------------------------------


Avg Baseline Decompression time = 130.13 sec

Avg Precise Decompression time = 131.036666667 sec



Speedup in decompression time = -0.696739158278%
------------------------------------------------
```

#### Gzip
For gzip2, you will find average compression/
decompression time for both baseline and precise version.
If you want to check individual result of
each iteration, you can check the file:
`result-gzip.txt` in Docker at path:
`/usr/src/artifact-cgo/performance/test/`
```
===================================
Final result of gzip
===================================


Avg Baseline Compression time = 58.1166666667 sec

Avg Precise Compression time = 58.8833333333 sec



Speedup in compression time = -1.31918554631%
------------------------------------------------


Avg Baseline Decompression time = 10.32 sec

Avg Precise Decompression time = 10.37 sec



Speedup in decompression time = -0.484496124031%
------------------------------------------------
```

#### SQLite
For SQLite, you will find average
time to process `100` selects on a SQL
database with `2,500,000` insertions,
for both baseline and precise version.
If you want to check individual result of
each iteration, you can check the file:
`result-sqlite.txt` in Docker at path:
`/usr/src/artifact-cgo/performance/test/`

```
===================================
Final result of SQLite
===================================


Avg Baseline SQLite = 82.69 sec

Avg Precise SQLite = 80.0566666667 sec



Speedup in SQLite = 3.18458499617%
------------------------------------------------
```

#### Stockfish
For Stockfish, you will find total
time for computing the next move in
`42` chess games that are part of its
test suite, for both baseline and precise version.
If you want to check individual result of
each iteration, you can check the file:
`result-stockfish.txt` in Docker at path:
`/usr/src/artifact-cgo/performance/test/`

```
===================================
Final result of Stockfish
===================================


Avg total time for Baseline Stockfish = 270.563333333 sec

Avg total time for Precise Stockfish = 268.328sec



Speedup in SQLite = 0.826177481551%
------------------------------------------------
```

**NOTE**: The speedup numbers may vary depending on which
architecture you are using, and what is the configuration
of the machine or because of several other factors.

## Section 4.7

```
===========================================
 Evaluation: (Soundness bugs) Section 4.7
===========================================


----------------------------------------------------------
Testing Soundness Bug #1 in non-zero dataflow analysis
----------------------------------------------------------

%0:i32 = add 0:i32, 0:i32
infer %0

known nonZero from souper: false

known nonZero from compiler: true
; Listing valid replacements.
; Using solver: Z3 + internal cache

; Static profile 1
; Function: foo
%0:i32 = add 0:i32, 0:i32
cand %0 0:i32
```

# Customization: How to use our tool for extended testing?

