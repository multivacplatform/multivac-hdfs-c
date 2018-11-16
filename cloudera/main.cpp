#include <string>
#include <stdio.h>
#include <sstream>
#include <fstream>
#include <iostream>
#include <getopt.h>
#include <list>
#include <random>
#include <iostream>
#include <cstring>
#include <iostream>

#include "hdfs.h"

// API can find be there : http://doc.mapr.com/display/MapR/APIs
// Sample programm from here : https://hadoop.apache.org/docs/r2.4.1/hadoop-project-dist/hadoop-hdfs/LibHdfs.html

tSize write_file(std::string filename)
{
	hdfsFS fs = hdfsConnect("default", 0);
	const char *writePath = filename.c_str();
	hdfsFile writeFile = hdfsOpenFile(fs, writePath, O_WRONLY | O_CREAT, 0, 0, 0);
	if (!writeFile)
	{
		fprintf(stderr, "Failed to open %s for writing!\n", writePath);
	}
	char *buffer = (char *)"Hello, World!";
	tSize num_written_bytes = hdfsWrite(fs, writeFile, (void *)buffer, strlen(buffer) + 1);
	if (hdfsFlush(fs, writeFile))
	{
		fprintf(stderr, "Failed to 'flush' %s\n", writePath);
	}
	hdfsCloseFile(fs, writeFile);
	return num_written_bytes;
}

int main(int argc, char **argv)
{

	std::string filename;
	std::cin >> filename;
	if (filename == "")
	{
		exit(0);
	}
	tSize nb = 0;
	nb = write_file(filename);
	std::cout << "fname:" << filename << ":" << nb << std::endl;
}
