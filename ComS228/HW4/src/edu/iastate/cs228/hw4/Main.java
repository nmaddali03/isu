package edu.iastate.cs228.hw4;
/**
 * Project 4: Archived Message Reconstruction
 *
 * @author Neha Maddali
 * @version 1.0
 */

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Main {
	/**
	  * Main method taking the arch file and reading the file. The user will enter the file system name of their
	  * arch file. 
	  * The file contains up to three lines. The first two can be for the tree construction and the last line
	  * is for the decoding method as it consists of binary digits. 
	  * The message is decoded and printed to the console.
	  * @param 
	  * @return
	  */
	public static void main(String args[]) throws FileNotFoundException { 
		//scanner for use input
		Scanner user = new Scanner(System.in); 
		String  inputFileName;

		//input file (for example: src/edu/iastate/cs228/hw4/cadbard.arch)
		System.out.print("Input File Name: ");
		inputFileName = user.nextLine().trim();
		File input = new File(inputFileName);      
		Scanner sc = new Scanner(input); 
		String treeString = sc.nextLine(); //get the first line of the file
		String test = sc.nextLine(); //get the second line of the file
		String messageString = ""; //create empty messageString variable for the binary string

		if(sc.hasNextLine()) { //if there is a third line in the file
			treeString = treeString + '\n' + test; //combine the first two lines of preorder traversal 
			messageString = sc.nextLine(); //the next line is the binary string
		}else { //if there are only two lines in the file
			messageString = test;  //the second line will be the binary string
		}

		MsgTree newTree = new MsgTree(treeString); //create the MsgTree
		String code = "";

		System.out.println("Character code");
		System.out.println("-------------------------");

		MsgTree.printCodes(newTree, code); //print the character codes
		System.out.println();
		System.out.println("MESSAGE:");
		newTree.decode(newTree, messageString); //print the encoded message
	}
}
