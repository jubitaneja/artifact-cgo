# Build and Install SPEC CPU 2017

- Follow the steps:
```
Copy SPEC ISO (cpu2017-1_0_1.iso) to $HOME
$ mkdir $HOME/spec
$ mount -t iso9660 -o ro,exec,loop $HOME/cpu2017-1_0_1.iso $HOME/spec
$ $HOME/spec/install.sh
```

- Follow the installation wizard and install at `$HOME/cpu2017`

- Copy `souper-cache.cfg` from https://gist.github.com/zhengyangl/9d6c79beded94584f35292ee00c964e9
..to `$HOME/cpu2017/config`

- You can update `sclang` binary path ($HOME/souper/build/sclang)
in `$HOME/cpu2017/config/souper-cache.cfg`
at [line 191](https://gist.github.com/zhengyangl/9d6c79beded94584f35292ee00c964e9#file-souper-cache-cfg-L191).

# Setup Redis

- Invoke redis-server in a different shell.
```
$ redis-server
```
Make sure there are no keys
in any existing redis. You can check the keyspace by:
```
$ redis-cli dbsize
```
This should return `0`. If not, you can flush the keys, and shutdown the existing redis.
```
$ redis-cli flushall
$ redis-cli shutdown
```

# Set Souper environment variables

```
$ export SOUPER_STATIC_PROFILE=1
$ export SOUPER_IGNORE_SOLVER_ERRORS=1
$ export SOUPER_NO_INFER=1
$ export SOUPER_SOLVER="-z3-path=/path/to/z3"
```

# Run SPEC benchmark
```
$ cd $HOME/cpu2017
$ . shrc
$ runcpu -D --config=souper-cache --action=build --tune=base intspeed fpspeed
```
After the SPEC build finishes, you can check the redis dbsize to find
out that there should be `269,113` keys. Check by running `redis-cli dbsize`

# Evaluation: Table 1 (Precision Testing of each DFA)

We are now finally ready to test precision of each dataflow fact
evaluated in Table 1.

### Set Memory Limit
We recommend setting memory limit, so that your machine does not hang
by using the entire swap space. The precision testing experiment
consumes a lot of memory. For instance, we set the memory limit to
2GB in our experiments.
```
$ ulimit -Sv 2000000
```
### Set Execution Time
We also limit execution time of `souper-check` and `Z3` in `crontab`
to keep running these experiments at a faster pace.
```
$ crontab -e
*/5 * * * *  killall -u YourUserName -older-than 5m souper-check
*/5 * * * *  killall -u jubi -older-than 15m z3
```

### Run Precision Testing Script
- For known bits dataflow fact:
```
$ $HOME/souper/build/cache_dfa --knownbits > known.txt
```

- For negative dataflow fact:
```
$ $HOME/souper/build/cache_dfa --neg > negative.txt
```

- For non-negative dataflow fact:
```
$ $HOME/souper/build/cache_dfa --nonneg > non-negative.txt
```

- For non-zero dataflow fact:
```
$ $HOME/souper/build/cache_dfa --nonzero > non-zero.txt
```

- For power of two dataflow fact:
```
$ $HOME/souper/build/cache_dfa --power > power.txt
```

- For number of sign bits dataflow fact:
```
$ $HOME/souper/build/cache_dfa --signBits > signBits.txt
```

- For range dataflow fact:
```
$ $HOME/souper/build/cache_range > range.txt
```

- For demanded bits dataflow fact:
```
$ $HOME/souper/build/cache_demandedbits > db.txt
```

### Process the results 

