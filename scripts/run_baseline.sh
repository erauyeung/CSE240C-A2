#!/bin/bash

policy=base
binname=base
# 10 mil
warmup=10000000
# 100 mil
sim=100000000
# location of traces
tracesource=/datasets/cs240c-wi22-a00-public/data/Assignment2-gz/
# output folder
outfolder=output_$binname

# Single-core without prefetcher
if ! [ -f bin/$binname-config1 ]
then
  echo "Compiling baseline.g, 1-core, no prefetcher"
  g++ -Wall --std=c++11 -o bin/$binname-config1 example/lru.cc lib/config1.a
fi

# Single-core with prefetcher
if ! [ -f bin/$binname-config2 ]
then
  echo "Compiling baseline.g, 1-core, with L1/L2 prefetchers"
  g++ -Wall --std=c++11 -o bin/$binname-config2 example/lru.cc lib/config2.a
fi

echo "Moving on to config1"
# config1: 1-core, no prefetch
for trace in ${tracesource}*.trace.gz; do
  # Chop off the "/datasets/cs240c-wi22-a00-public/data/Assignment2-gz/"
  cleantrace=${trace#$tracesource}
  output="$binname-config1-w$warmup-s$sim-$cleantrace.txt"
  if ! [ -f "$outfolder/$output" ]
  then
    echo "./bin/$binname-config1 -warmup_instructions $warmup -simulation_instructions $sim -traces $trace > $outfolder/$output"
    ./bin/$binname-config1 -warmup_instructions $warmup -simulation_instructions $sim -traces $trace > "$outfolder/$output" &
  fi
done

echo "Moving on to config2"
# config2: 1-core, L1/L2 prefetch
for trace in ${tracesource}*.trace.gz; do
  # Chop off the "/datasets/cs240c-wi22-a00-public/data/Assignment2-gz/"
  cleantrace=${trace#$tracesource}
  output="$binname-config2-w$warmup-s$sim-$cleantrace.txt"
  if ! [ -f "$outfolder/$output" ]
  then
    echo "./bin/$binname-config2 -warmup_instructions $warmup -simulation_instructions $sim -traces $trace > $outfolder/$output"
    ./bin/$binname-config2 -warmup_instructions $warmup -simulation_instructions $sim -traces $trace > "$outfolder/$output" &
  fi
done
