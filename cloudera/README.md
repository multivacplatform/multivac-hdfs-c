# Compile c/c++ against native Hadoop library on Cloudera

```bash
# Optional
export JAVA_HOME=/usr/lib/jvm/java-8-oracle/
export HADOOP_CONF_DIR=/etc/hadoop/conf:/etc/hive/conf

# Very important when you are executing the C/C++ code. This helps the JAVA to find and link the libraries (classpath) if I am not mistaken
export LD_LIBRARY_PATH=/usr/lib/jvm/java-8-oracle/jre/lib/amd64/server:/opt/cloudera/parcels/CDH/lib/
export CLASSPATH=$CLASSPATH:`hadoop classpath --glob`

# How to link C/C++ to the right headers and Hadoop native libraries
g++ -o compiled/cpp_exe main.cpp -std=c++11 -I/opt/cloudera/parcels/CDH/include/ -L/opt/cloudera/parcels/CDH/lib/ -lhdfs
```

# Spark RDD Pipe()
## Cloudera (YARN and HDFS)
Simple Spark/Scala snippets of how to run a compiled `C/C++` which receives some paths and writes `Hello Wordl!` in those paths.

```scala
// Add the file to all executors in YARN
val distScript = "hdfs:///tmp/cpp_exe"
sc.addFile(distScript)

import sys.process._
import java.nio.file.{ Paths, Files }

var inputs_points  = sc.parallelize(List("/user/YOUR_USERNAME/tmp/file.txt","/user/YOUR_USERNAME/tmp/file2.txt","/user/YOUR_USERNAME/tmp/file3.txt"))
// To access HDFS CLASSPATH and LD_LIBRARY_PATH must be set on all executors
var env_map = Map(
    "CLASSPATH" -> "hadoop classpath --glob".!!,
    "LD_LIBRARY_PATH" -> "/usr/lib/jvm/java-8-oracle/jre/lib/amd64/server:/opt/cloudera/parcels/CDH/lib/"
)
// Important: Run Spark RDD Pipe() with env option
val exe_path = inputs_points.pipe(command = Seq("./cpp_exe"),
                                  env = env_map)
exe_path.collect().map(println(_))

```
```bash
import sys.process._
import java.nio.file.{Paths, Files}
inputs_points: org.apache.spark.rdd.RDD[String] = ParallelCollectionRDD[6] at parallelize at <console>:29
exe_path: org.apache.spark.rdd.RDD[String] = PipedRDD[7] at pipe at <console>:29
fname:/user/YOUR_USERNAME/tmp/file.txt:14
fname:/user/YOUR_USERNAME/tmp/file2.txt:14
fname:/user/YOUR_USERNAME/tmp/file3.txt:14
res4: Array[Unit] = Array((), (), ())
```

## Important Note

1. In YARN cluster/client mode, if the `C/C++` or any exeternal application needs access to HDFS, the following items must be set properly in order to execute the YARN container as the same user in Spark to have the right permissions on HDFS directories (otherwise, the user will be either `yarn` or `nbody`):

```
yarn.nodemanager.container-executor.class

yarn.nodemanager.linux-container-executor.nonsecure-mode.limit-users
```
https://hadoop.apache.org/docs/r3.0.0/hadoop-yarn/hadoop-yarn-site/NodeManagerCgroups.html

2. To not interfere with Apache Spark and other components of Hadoop it's best to set env variables via bash script (ex: `run_c.sh`) 
