#!/bin/bash

# Source VTune environment in script to enable VTune command in new shell created with script
. /opt/intel/oneapi/setvars.sh

mkdir -p /opt/platypus/vtune-results
resultsDir=/opt/platypus/vtune-results
regressionTestDir=/opt/platypus/test/tests/kernels
analysisType="hotspots"

cd $regressionTestDir || exit 1
shopt -s nullglob
for inputFile in $regressionTestDir/*.i; do
    testName="$(basename "$inputFile" .${inputFile##*.})"
    
    echo "------------------------------------------------------------------"
    echo "Running Intel VTune $analysisType on $testName regression test" 
    echo "------------------------------------------------------------------"

    cd $resultsDir
    vtune -collect hotspots -strategy=:trace:trace -result-dir="$resultsDir/$testName" /opt/platypus/platypus-opt -i $inputFile
    vtune -report summary -r "$resultsDir/$testName" -format=html > "${testName}_${analysisType}_summary.html"
    tar -cvf "${testName}_${analysisType}_results".tar $testName 
done

tar -cvf "regression_test_${analysisType}_summaries.tar" *.html 
