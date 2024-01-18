package edu.iastate.cs228.hw3;

/**
 * Infix to Postfix converter
 *
 * @author Neha Maddali
 * @version 1.0
 */

import java.util.Stack;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

class Infix2Postfix
{
	/**
	  * Driver method to take an input file and convert lines of infix to postfix in output file
	  * @param 
	  * @return
	  */
	public static void main(String[] args) throws FileNotFoundException
	{
		//get input file
		File file = new File("src/edu/iastate/cs228/hw3/input.txt");
		Scanner sc = new Scanner(file);

		//while there is a next line in the text file
		while(sc.hasNextLine()) {
			//each line in the text file is one infix expression that is saved as a string
			String expr = sc.nextLine();
			try {
				//write the postfix expression to the output file
				FileWriter myWriter = new FileWriter("src/edu/iastate/cs228/hw3/output.txt",true);
				myWriter.write(infixToPostfix(expr)+"\n");
				myWriter.close();
			}
			catch(IOException e) {
				//if there is an error in writing to file:
				System.out.println("An error occured");
			}
		}
		sc.close();
	}

	/**
	  * A utility function to return precedence of a given operator Higher returned value means
	  * higher precedence
	  * @param char ch
	  * @return int precedence
	  */
	static int Prec(char ch)
	{
		switch (ch)
		{
		case '+':
		case '–':
			return 1;
		case '-':
			return 1;
		case '*':
		case '/':
			return 2;
		case '%':
			return 2;
		case '^':
			return 3;
		}
		return -1;
	}
	

	// The main method that converts given infix expression to postfix expression. 
	/**
	  * method that converts given infix expression to postfix expression
	  * @param String exp
	  * @return String result
	  */
	static String infixToPostfix(String exp)
	{
		// initializing empty String for result
		String result = new String("");

		// initializing empty stack
		Stack<Character> stack = new Stack<>();

		int rank = 0;
		String[] arr = exp.split(" ",-3);
		
		//for loop to check the rank of the character to produce errors for too many operators or operands
		for(int i = 0; i<arr.length; i++) {
			if(arr[i].equals("+") || arr[i].equals("-") || arr[i].equals("/") 
					|| arr[i].equals("*") || arr[i].equals("^") || arr[i].equals("%")
					|| arr[i].equals("–")) {
				rank -= 1;
			}
			else if(arr[i].equals("(") || arr[i].equals(")")) {
			}
			else {
				rank += 1;
			}
			
			if(rank > 1) {
				result = "Error: too many operands (" + arr[i] +")";
				return result;
			}
			else if(rank<0) {
				result = "Error: too many operators (" + arr[i] +")";
				return result;
			}
		}
		
		if(rank != 1) {
			result = "Error: too many operators (" + arr[arr.length-1] +")";
			return result;
		}
		
		for (int i = 0; i<exp.length(); ++i)
		{
			char c = exp.charAt(i);
			// If the scanned character is an operand, add it to output.
			if (Character.isLetterOrDigit(c)) {	
				result += c;
			}			
			// If the scanned character is an '(', push it to the stack.
			if (c == '(') {
				stack.push(c);
			}

			//  If the scanned character is an ', pop and output from the stack 
			// until an '(' is encountered.
			else if (c == ')')
			{
				int counter = 0;
				while (!stack.isEmpty() && stack.peek() != '(') {
					result += " "+stack.pop();
					counter++;
				}
				//if counter is 0 then there is a set of parenthesis with no subexpression
				if(counter == 0) {
					result = "Error: no subexpression detected";
					return result;
				}
				if (stack.isEmpty()) {
					result = "Error: no opening parenthesis detected";
					return result;
				}
				while (stack.peek() != '(') {
					result += stack.pop() + " ";
					return result;
				}
				stack.pop();
			}
			// an operator is encountered
			else if(Prec(c) != -1)
			{
				while (!stack.isEmpty() && Prec(c) <= Prec(stack.peek())){
					result += " "+stack.pop();
				}
				stack.push(c);
			}
		}
		// pop all the operators from the stack
		while (!stack.isEmpty()){
			if (Character.isLetterOrDigit(stack.peek())) {
				result += stack.pop() + " ";
			}
			//check for proper closing parenthesis
			else if(stack.peek() == '(' || stack.peek() == ')') {
				result = "Error: no closing parenthesis detected";
				return result;
			}
			result += " "+stack.pop();
		}
		return result;
	}
}