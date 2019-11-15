Performance evaluation

```
$ cd ${CGO_HOME}
$ ./build_souper_performance.sh
```


## Evaluation: gzip


## Evaluation: bzip2


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
$ time make build ARCH=x86-64-modern COMPCXX=${CGO_HOME}/scratch/performance/build/bin/clang++

$ cd {CGO_HOME}/scratch/performance/test/stockfish/baseline
$ time make build ARCH=x86-64-modern COMPCXX=${CGO_HOME}/scratch/performance/baseline/bin/clang++


for i in {1..3}; do {CGO_HOME}/scratch/performance/test/stockfish/precise/src/stockfish bench 1024 1 26 >/dev/null ; done
for i in {1..3}; do {CGO_HOME}/scratch/performance/test/stockfish/baseline/src/stockfish bench 1024 1 26 >/dev/null ; done
```

# Evaluation: sqlite3
