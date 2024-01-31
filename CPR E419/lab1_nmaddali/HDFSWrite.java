import org.apache.hadoop.conf.*;
import org.apache.hadoop.fs.*;

public class HDFSWrite{
	public static void main(String [] args) throws Exception{
		//the system configuration
		//creates a configuration object to configure the Hadoop system
		Configuration conf = new Configuration();
		
		//get an instance of the FileSystem using configuration
		FileSystem fs = FileSystem.get(conf);
		
		//the path to the file that needs to be written
		String path_name = "/lab1/newfile";
		
		Path path = new Path(path_name);
		
		//the output data stream to write into
		FSDataOutputStream file = fs.create(path);
		
		//write some data
		file.writeChars("The first Hadoop Program!");
		
		//close the file and the file system instance
		file.close();
		fs.close();
	}
}

