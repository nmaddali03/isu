package lab1;
import java.util.*;

import class Greeter {
	public static void main(String[] args) {
		Scanner scan = new Scanner (System.in);
		System.out.print("What is your name:");
		String name = scan.nextLine();
		System.out.println("Hello "+ name);
	}	
}
