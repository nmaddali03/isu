import org.apache.hadoop.conf.*;
import org.apache.hadoop.fs.*;

public class Checksum {

	public static void main(String[] args) throws Exception {
		//the system configuration
		Configuration conf = new Configuration();
		
		//get an instance of FileSystem
		FileSystem fs = FileSystem.get(conf);
		
		String path_name = "/lab1/bigdata";
		
		Path path = new Path(path_name);
		
		//the output data stream to write into
		FSDataInputStream file = fs.open(path);
		
		//create an empty byte array to store data
		byte buffer[] = new byte[1000];
		file.readFully(1000000000, buffer);
		int check = buffer[0];
		for(int i=1; i<buffer.length;i++) {
			check ^= buffer[i];
		}
		
		System.out.println("Checksum: "+check);
		file.close();
		fs.close();
	}

}