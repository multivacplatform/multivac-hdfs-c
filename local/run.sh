#!/bin/bash

## ============ Variable to set ==================
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/"
export MASTER_IP="localhost"

print_fun() # Show a list of functions
{
    grep "^function" $0
}

if [ $# -eq 0 ]
then
    echo "=> functions aviable are : "
    print_fun
    exit 1;
fi


function download
{

    wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz
    wget https://github.com/sbt/sbt/releases/download/v1.0.0/sbt-1.0.0.tgz
    wget https://archive.apache.org/dist/hadoop/core/hadoop-2.7.0/hadoop-2.7.0-src.tar.gz

}


function extract
{
    tar -xvf spark-2.2.0-bin-hadoop2.7.tgz
    tar -xvf sbt-1.0.0.tgz
    tar -xvf hadoop-2.7.0-src.tar.gz
}

function clean
{
    rm -rf ./hadoop-2.7.0-src ./metastore_db/ ./sbt ./spark-2.2.0-bin-hadoop2.7
}



## =======  Other variables ========
export HDFS_LIBS_PATH=${PWD}/hadoop-2.7.0-src/hadoop-hdfs-project/hadoop-hdfs/src/build/target/usr/local/lib/
export HDFS_INCLUDE_PATH=${PWD}/hadoop-2.7.0-src/hadoop-hdfs-project/hadoop-hdfs/src/main/native/libhdfs/
export CLASSPATH=.:$JAVA_HOME/lib/
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${HDFS_LIBS_PATH}




function compile_hadoop
{ 
    echo "=============================================="
    echo " compile hadoop ...  " 
    mkdir -p ./hadoop-2.7.0-src/hadoop-hdfs-project/hadoop-hdfs/src/build/
    cd ./hadoop-2.7.0-src/hadoop-hdfs-project/hadoop-hdfs/src/build/
    awk 'NR==23{$0="set(GENERATED_JAVAH true)\n"$0}1' ../CMakeLists.txt > ../CMakeLists.txt.tmp && mv ../CMakeLists.txt.tmp ../CMakeLists.txt
    cmake ../
    make
    cd -
}

function compile_cpp
{

    echo "=============================================="
    echo " compile c++ ...  " 
    echo "g++ -o cpp_exe main.cpp  -std=c++11  -I${HDFS_INCLUDE_PATH} -L${HDFS_LIBS_PATH} -lhdfs"
    
}



function run_spark
{
    echo "export SPARK_MASTER_HOST=${MASTER_IP}" > ./spark-2.2.0-bin-hadoop2.7/conf/spark-env.sh
    ./spark-2.2.0-bin-hadoop2.7/sbin/start-master.sh
    ./spark-2.2.0-bin-hadoop2.7/sbin/start-slave.sh spark://${MASTER_IP}:7077
    ./spark-2.2.0-bin-hadoop2.7/bin/spark-shell -i ./main.scala \
						--master spark://${MASTER_IP}:7077 \
						--conf spark.executor.extraLibraryPath=${LD_LIBRARY_PATH} 
}



$@

#res0: Array[String] = Array(fname:/tmp/file1.txt:-1, fname:/tmp/file2.txt:-1, fname:/tmp/file3.txt:-1)


#https://stackoverflow.com/questions/16860021/undefined-reference-to-jni-createjavavm-linux
