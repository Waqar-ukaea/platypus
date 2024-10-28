#!/bin/bash

resultsDir=/opt/platypus/vtune-results
workdir=/opt/platypus/test/tests/kernels
analysisType="hotspots"

cd $regressionTestDir || exit 1

for inputFile in $regressionTestDir/*.i; do
    [ -e "$inputFile" ] || echo "No input files avaialble in regression testsuite. Check Platypus bu>
    testName="$(basename "$inputFile" .${inputFile##*.})"
    
    echo "------------------------------------------------------------------"
    echo "Running Intel VTune $analysisType on $testName regression test" 
    echo "------------------------------------------------------------------"

    vtune -collect hotspots -strategy=:trace:trace -result-dir="$resultsDir/$testName" /opt/platypus>
    cd $resultsDir
    vtune -report summary -r "$resultsDir/$testName" -format=html > "${testName}_${analysisType}_sum>
    tar -cvf "${testName}_${analysisType}_results".tar $testName 
done


