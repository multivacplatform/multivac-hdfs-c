import sys.process._
import java.nio.file.{ Paths, Files }

val distScript = "hdfs:///YOUR_HOME/tmp/cpp_exe"
val bashScript = "hdfs:///YOUR_HOME/tmp/run_c.sh"
sc.addFile(distScript)
sc.addFile(bashScript)

val filePath = List("/user/YOUR_HOME/tmp/file.txt","/user/YOUR_HOME/tmp/file2.txt","/user/YOUR_HOME/tmp/file3.txt")
val partitionCount = filePath.length.toInt
val inputs_points  = sc.parallelize(filePath).repartition(partitionCount)

val exe_path2 = inputs_points.pipe(Seq("./run_c.sh"))
exe_path2.collect().map(println(_))
