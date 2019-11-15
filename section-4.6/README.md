Performance evaluation

## Preparation

```
$ cd ${CGO_HOME}
$ ./build_souper_performance.sh
$ export Z3_PATH=${CGO_HOME}/scratch/performance/souper/third_party/z3-install/bin/z3

$ dd if=/dev/urandom bs=1M count=512 of={CGO_HOME}/scratch/performance/test/512mb
$ wget https://github.com/jubitaneja/artifact-cgo/blob/master/section-4.6/db.sq.gz -o {CGO_HOME}/scratch/performance/test/db.sq.gz
$ wget https://github.com/jubitaneja/artifact-cgo/blob/master/section-4.6/test4.sql -o {CGO_HOME}/scratch/performance/test/test4.sql
$ gzip -d {CGO_HOME}/scratch/performance/test/db.sq.gz

```


## Evaluation: gzip

```
$ mkdir -p {CGO_HOME}/scratch/performance/test/gzip/precise
$ mkdir -p {CGO_HOME}/scratch/performance/test/gzip/baseline
$ cd {CGO_HOME}/scratch/performance/test/gzip
$ wget http://ftp.gnu.org/gnu/gzip/gzip-1.10.tar.gz
$ tar xvf gzip-1.10.tar.gz
$ cp -r gzip-1.10 baseline
$ mv gzip-1.10 precice

$ cd {CGO_HOME}/scratch/performance/test/gzip/precise
$ time make -j32 CC=${CGO_HOME}/scratch/performance/build/bin/clang CFLAGS="-O3 -z3_path=${Z3_PATH}"

$ cd {CGO_HOME}/scratch/performance/test/gzip/baseline
$ time make -j32 CC=${CGO_HOME}/scratch/performance/baseline/bin/clang CFLAGS="-O3"

$ for i in {1..3}; do {CGO_HOME}/scratch/performance/test/gzip/precise/gzip -f -k {CGO_HOME}/scratch/performance/test/512mb ; done
$ for i in {1..3}; do {CGO_HOME}/scratch/performance/test/gzip/baseline/gzip -f -k {CGO_HOME}/scratch/performance/test/512mb ; done

```

## Evaluation: bzip2
```
$ mkdir -p {CGO_HOME}/scratch/performance/test/bz2/precise
$ mkdir -p {CGO_HOME}/scratch/performance/test/bz2/baseline
$ cd {CGO_HOME}/scratch/performance/test/bz2
$ wget https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz
$ tar xvf bzip2-1.0.8.tar.gz
$ cp -r bzip2-1.0.8 baseline
$ mv bzip2-1.0.8 precice

$ cd {CGO_HOME}/scratch/performance/test/bz2/precise
$ time make CC=${CGO_HOME}/scratch/performance/build/bin/clang CFLAGS="-Wall -Winline -O3 -g -D_FILE_OFFSET_BITS=64 -z3_path=${Z3_PATH}"

$ cd {CGO_HOME}/scratch/performance/test/bz2/baseline
$ time make CC=${CGO_HOME}/scratch/performance/baseline/bin/clang CFLAGS="-Wall -Winline -O3 -g -D_FILE_OFFSET_BITS=64"

$ for i in {1..3}; do {CGO_HOME}/scratch/performance/test/bz2/precise/bzip2 -f -k {CGO_HOME}/scratch/performance/test/512mb ; done
$ for i in {1..3}; do {CGO_HOME}/scratch/performance/test/bz2/baseline/bzip2 -f -k {CGO_HOME}/scratch/performance/test/512mb ; done
```

# Evaluation: stockfish
```
$ mkdir -p {CGO_HOME}/scratch/performance/test/stockfish/precise
$ mkdir -p {CGO_HOME}/scratch/performance/test/stockfish/baseline

$ cd {CGO_HOME}/scratch/performance/test/stockfish
$ wget https://stockfishchess.org/files/stockfish-10-src.zip
$ cp stockfish-10-src.zip precise
$ cp stockfish-10-src.zip baseline
$ cd {CGO_HOME}/scratch/performance/test/stockfish/precise && unzip stockfish-10-src.zip
$ cd {CGO_HOME}/scratch/performance/test/stockfish/baseline && unzip stockfish-10-src.zip

$ cd {CGO_HOME}/scratch/performance/test/stockfish/precise
$ time make build ARCH=x86-64-modern COMPCXX=${CGO_HOME}/scratch/performance/build/bin/clang++ CFLAGS="-z3_path=${Z3_PATH}"

$ cd {CGO_HOME}/scratch/performance/test/stockfish/baseline
$ time make build ARCH=x86-64-modern COMPCXX=${CGO_HOME}/scratch/performance/baseline/bin/clang++


$ for i in {1..3}; do {CGO_HOME}/scratch/performance/test/stockfish/precise/src/stockfish bench 1024 1 26 >/dev/null ; done
$ for i in {1..3}; do {CGO_HOME}/scratch/performance/test/stockfish/baseline/src/stockfish bench 1024 1 26 >/dev/null ; done
```

# Evaluation: sqlite3
```

$ mkdir -p {CGO_HOME}/scratch/performance/test/sqlite3/precise
$ mkdir -p {CGO_HOME}/scratch/performance/test/sqlite3/baseline

$ cd {CGO_HOME}/scratch/performance/test/sqlite3
$ wget https://www.sqlite.org/2019/sqlite-amalgamation-3290000.zip
$ cp sqlite-amalgamation-3290000.zip precise
$ cp sqlite-amalgamation-3290000.zip baseline
$ unzip sqlite-amalgamation-3290000.zip
$ cp -r sqlite-amalgamation-3290000 baseline
$ mv sqlite-amalgamation-3290000 precise

$ cd {CGO_HOME}/scratch/performance/test/sqlite3/precise
$ time ${CGO_HOME}/scratch/performance/build/bin/clang -lpthread -ldl -O3 -o sqlite3 sqlite3.c shell.c -z3_path=${Z3_PATH}

$ cd {CGO_HOME}/scratch/performance/test/sqlite3/baseline
$ time ${CGO_HOME}/scratch/performance/baseline/bin/clang -lpthread -ldl -O3 -o sqlite3 sqlite3.c shell.c

$ cd {CGO_HOME}/scratch/performance/test/sqlite3

$ cat ./test4.sql | time precise/sqlite3 db.sq > /dev/null
$ cat ./test4.sql | time baseline/sqlite3 db.sq > /dev/null
```
