#!/bin/bash

#$1 base or ondemand
#$2 or $3 = name of bytecode to analyze or/and complementary pass
#$2 or $3 = name of bytecode to analyze or/and complementary pass



opt -load RangeAnalysis.so -load SRAA_${1}.so -disable-output -stats -time-passes -sraa $2 $3 -debug-only=aresult
