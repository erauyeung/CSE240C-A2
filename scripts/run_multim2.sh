#!/bin/bash

policy=multi
binname=multim2
# 10 mil
warmup=10000000
# 100 mil
sim=100000000
# location of traces
tracesource=/datasets/cs240c-wi22-a00-public/data/Assignment2-gz/
# output folder
outfolder=output_$binname

# Single-core with prefetcher
for n in {1..3};
do
  echo "Compiling $binname-$n, 1-core, with L1/L2 prefetchers"
  grep "dan_theta = " $policy/$binname-$n.cc
  grep "dan_theta2 = " $policy/$binname-$n.cc
  g++ -Wall --std=c++11 -o bin/$binname-$n-config2 $policy/$binname-$n.cc lib/config2.a
done

# config2: 1-core, L1/L2 prefetch
for trace in ${tracesource}*.trace.gz; do
  cleantrace=${trace#$tracesource}
  for n in {1..3};
  do
    output="$binname-$n-config2-w$warmup-s$sim-$cleantrace.txt"
    if ! [ -f "$outfolder/$output" ]
    then
      echo "./bin/$binname-$n-config2 -warmup_instructions $warmup -simulation_instructions $sim -traces $trace > $outfolder/$output"
      ./bin/$binname-$n-config2 -warmup_instructions $warmup -simulation_instructions $sim -traces $trace > "$outfolder/$output" &
    fi
  done
done
