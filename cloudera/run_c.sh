#!/bin/bash
filePath=$1
export CLASSPATH=`hadoop classpath --glob`
export LD_LIBRARY_PATH=/usr/lib/jvm/java-8-oracle/jre/lib/amd64/server:/opt/cloudera/parcels/CDH/lib/

echo "Running shell script $filePath"
./cpp_exe $filePath
