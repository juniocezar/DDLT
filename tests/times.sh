#!/bin/bash

INDIR="bytecodes"
#PASS="-licm" #licm #aa-eval #O3 #instcombine

PASS=$( echo $1 )
OUTDIR=$( echo "results/time${PASS}" ) #licm #aaeval #o3 #instcombine

if [ ! -d "$OUTDIR" ]; then
  mkdir $OUTDIR
fi

echo "PASSE $PASS"

O3=""
TIMES=1

for TIME in $( seq 1 $TIMES ); do
  for FILE in $( ls -1Sr ${INDIR}/*.bc ); do
    NAME=$(basename $FILE | sed -e 's/\..*//')
    echo "=========== ANALYZING FILE $NAME via base $TIME =============="
    time opt -load RangeAnalysis.so -load SRAA_base.so -disable-output -disable-verify -stats -time-passes -track-memory -sraa -debug-pass=Arguments $PASS $FILE 2>>${OUTDIR}/${NAME}.base-${TIME}.out

    echo "=========== ANALYZING FILE $NAME via demand-driven $TIME =============="
    time opt -load RangeAnalysis.so -load SRAA_ondemand.so -disable-output -disable-verify -stats -time-passes -sraa -track-memory -debug-pass=Arguments $PASS $FILE 2>>${OUTDIR}/${NAME}.od-${TIME}.out
  done
done

