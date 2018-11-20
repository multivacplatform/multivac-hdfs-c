#!/bin/bash
filePath=$1
export CLASSPATH=`hadoop classpath --glob`
echo "Running shell script $filePath"
./cpp_exe $filePath
