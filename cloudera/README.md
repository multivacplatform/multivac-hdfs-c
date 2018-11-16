# Compile c/c++ Against native Hadoop library on Cloudera

```bash
# Optional
export JAVA_HOME=/usr/lib/jvm/java-8-oracle/
export HADOOP_CONF_DIR=/etc/hadoop/conf:/etc/hive/conf

# Very important when you are executing the C/C++ code. This helps the JAVA to find and link the libraries (classpath) if I am not mistaken
export LD_LIBRARY_PATH=/usr/lib/jvm/java-8-oracle/jre/lib/amd64/server:/opt/cloudera/parcels/CDH/lib/
export CLASSPATH=$CLASSPATH:`hadoop classpath --glob`

# How to link C/C++ to the right headers and Hadoop native libraries
g++ -o compiled/cpp_exe2 main.cpp -std=c++11 -I/opt/cloudera/parcels/CDH/include/ -L/opt/cloudera/parcels/CDH/lib/ -lhdfs
```
