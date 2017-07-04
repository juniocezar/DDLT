#!/bin/bash

INDIR="bytecodes"
#PASS="-licm" #licm #aa-eval #O3 #instcombine

OUTDIR=$( echo "results/time-o3" ) #licm #aaeval #o3 #instcombine



O3="-sraa -targetlibinfo -tti -assumption-cache-tracker -ipsccp -globalopt -deadargelim -domtree -instcombine -simplifycfg -basiccg -prune-eh -sraa -inline-cost -inline -sraa -functionattrs -sraa -argpromotion -domtree -sroa -early-cse -lazy-value-info -jump-threading -correlated-propagation -simplifycfg -domtree -sraa -instcombine -tailcallelim -simplifycfg -reassociate -domtree -loops -loop-simplify -lcssa -loop-rotate -sraa -licm -loop-unswitch -instcombine -scalar-evolution -loop-simplify -lcssa -indvars -sraa -loop-idiom -loop-deletion -loop-unroll -mldst-motion -domtree -memdep -gvn -memdep -memcpyopt -sccp -domtree -bdce -instcombine -lazy-value-info -jump-threading -correlated-propagation -domtree -memdep -sraa -dse -loops -loop-simplify -lcssa -licm -adce -simplifycfg -domtree -instcombine -barrier -float2int -domtree -loops -loop-simplify -lcssa -loop-rotate -branch-prob -block-freq -scalar-evolution -loop-accesses -sraa -loop-vectorize -instcombine -scalar-evolution -sraa -slp-vectorizer -simplifycfg -domtree -sraa -instcombine -loops -loop-simplify -lcssa -scalar-evolution -loop-unroll -sraa -instcombine -loop-simplify -lcssa -sraa -licm -scalar-evolution -alignment-from-assumptions -strip-dead-prototypes -elim-avail-extern -globaldce -constmerge -verify"

TIMES=3

for TIME in $( seq 1 $TIMES ); do
  for FILE in $( ls -1Sr ${INDIR}/*.bc ); do
    NAME=$(basename $FILE | sed -e 's/\..*//')
    echo "=========== ANALYZING FILE $NAME via base $TIME =============="
    time opt -load RangeAnalysis.so -load SRAA_base.so -disable-output -disable-verify -stats -time-passes $O3 -debug-pass=Arguments $FILE 2>>${OUTDIR}/${NAME}.base-${TIME}.out

    echo "=========== ANALYZING FILE $NAME via demand-driven $TIME =============="
    time opt -load RangeAnalysis.so -load SRAA_ondemand.so -disable-output -disable-verify -stats -time-passes $O3 -debug-pass=Arguments $FILE 2>>${OUTDIR}/${NAME}.od-${TIME}.out
  done
done

