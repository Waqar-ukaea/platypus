#!/bin/bash

# mkdir -p /opt/platypus/vtune-results
# results_dir=/opt/platypus/vtune-results
workdir=/home/waqar/platypus/test/tests/kernels
cd $work || exit 1

for inputFile in $workdir/*.i; do
    [ -e "$inputFile" ] || echo "No input files avaialble in regression testsuite. Check Platypus build."
    testName="$(basename "$inputFile" .${inputFile##*.})"
    echo $testName
    #vtune -collect hotspots -strategy=:trace:trace --app-working-dir= -result-dir="$r" /opt/platypus/bin/platypus -i $inputFile
    #vtune -report summary -format=html > "$testName_hotspots_summary.html"
    #tar -cvf testName_results.tar testName 

done
