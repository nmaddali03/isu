package edu.iastate.cs228.hw4;

/**
 * Project 4: Archived Message Reconstruction
 *
 * @author Neha Maddali
 * @version 1.0
 */

public class MsgTree {
	public char payloadChar;
	public MsgTree left;
	public MsgTree right;
	public static String encodingString;
	private static int staticCharIdx = 0;

	/**
	  * constructor building the tree from a string
	  * @param String encodingString
	  */
	public MsgTree(String encodingString){
		this(encodingString.charAt(staticCharIdx)); //get the character of the encodingString
		this.encodingString = encodingString;
		payloadChar = this.encodingString.charAt(staticCharIdx); //payloadChar = character of the encodingString
		if(payloadChar == '^') { //if the payloadChar is a ^ then there is a new set of children
			staticCharIdx++;
			this.left = new MsgTree(encodingString); //add the char to the tree to the left of the root
			staticCharIdx++;
			this.right = new MsgTree(encodingString); //add the char to the tree to the right of the root
		}
	}

	/**
	  * constructor for a single node with null children
	  * @param char payloadChar
	  */
	public MsgTree(char payloadChar){
		left = null; 
		right = null;
		this.payloadChar = payloadChar; 
	} 

	/**
	  * preorder traversal of the tree
	  * @param MsgTree newNode
	  */
	private void preOrderTraversal(MsgTree newNode) { 
		if(newNode == null) { 
			return;
		}
		System.out.printf("%s", newNode.payloadChar); 
		preOrderTraversal(newNode.left); 
		preOrderTraversal(newNode.right); 
	}
	
	/**
	  * print characters and their binary codes
	  * @param MsgTree root, String code
	  */
	public static void printCodes(MsgTree root, String code){
		if (root.left == null && root.right == null) {
			System.out.println(root.payloadChar + "     " + code);
		} else {
			if (root.left != null) {
				printCodes(root.left, code + '0'); //0 for left
			} if (root.right!=null) {
				printCodes(root.right, code + '1'); //1 for right
			}
		}
	}

	/**
	  * decodes the binary string based on the tree created and prints the message
	  * @param MsgTree codes, String msg
	  */
	public void decode(MsgTree codes, String msg) {	
		if (codes == null) { //if the tree is null return
			return;
		}
		char[] arr = msg.toCharArray();
		int index = 0;
		String message = ""; //empty string for message
		while (index < arr.length) { //while the index is less than the length of the binary string
			MsgTree node = codes; //the nodes of the tree created previously
			while (node != null) { //while the node is not null
				if (node.left == null && node.right == null) {
					message += node.payloadChar; //add the payloadChar to the message
					break;
				} else {
					char c = arr[index];
					if (c == '0') { //if the character is 0, the node is on the left
						node = node.left;
					} else {
						node = node.right; //if the character is 1, the node is on the right
					}
					
					index++;
				}
			}
		}
		System.out.println(message); //print the message to the console
	}
}