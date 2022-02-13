#!/bin/bash

policy=multi
binname=multis3
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
  if [ -f $policy/$binname-$n.cc ]
  then
    echo "Compiling $binname-$n, 1-core, with L1/L2 prefetchers"
    diff $policy/$policy.cc $policy/$binname-$n.cc
    g++ -Wall --std=c++11 -o bin/$binname-$n-config2 $policy/$binname-$n.cc lib/config2.a
  fi
done

# config2: 1-core, L1/L2 prefetch
for trace in ${tracesource}*.trace.gz; do
  cleantrace=${trace#$tracesource}
  for n in {1..3};
  do
    output="$binname-$n-config2-w$warmup-s$sim-$cleantrace.txt"
    if ! [ -f "$outfolder/$output" ]
    then
      #echo "./bin/$binname-$n-config2 -warmup_instructions $warmup -simulation_instructions $sim -traces $trace > $outfolder/$output"
      ./bin/$binname-$n-config2 -warmup_instructions $warmup -simulation_instructions $sim -traces $trace > "$outfolder/$output" &
    fi
  done
done

#for n in {1..3};
#do
#  ./bin/$binname-$n-config2 -warmup_instructions 1000000 -simulation_instructions 10000000 -traces trace/bzip2_10M.trace.gz > "test$n.txt"
#done
