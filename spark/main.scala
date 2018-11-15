import sys.process._
import java.nio.file.{ Paths, Files }

var inputs_points  = sc.parallelize(List("/tmp/file1.txt","/tmp/file2.txt","/tmp/file3.txt"));
val exe_path = Paths.get(".").toAbsolutePath.getParent + "/cpp_exe";
inputs_points.pipe(exe_path).collect()
