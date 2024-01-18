package finalLab;

import java.util.Scanner;

public class ContactList{
	public static void main(String[] args)
	{
		//create 3 refernces
		ContactNode p[]=new ContactNode[3];
		Scanner scnr = new Scanner(System.in);

		for(int i=0;i<3;i++) {
			int x = i+1;
			System.out.println("Person "+x);
			System.out.println("Enter name:");
			String name=scnr.nextLine();
			System.out.println("Enter phone number:");
			String phoneNumber=scnr.nextLine();
			System.out.println("You entered: "+name+", "+phoneNumber);
			System.out.println();
			//create a new object which will be referred by p[i]
			p[i]=new ContactNode(name,phoneNumber);
		}

		//make a linked list using 3 objects
		// p[0] -> p[1] -> p[2] -> null
		for(int i=1;i<3;i++) {
			p[i-1].insertAfter(p[i]);
		}

		System.out.println("CONTACT LIST");
		//create a reference to node(object) p[0]
		ContactNode c=p[0];

		while(c!=null){
			c.printContactNode();
			c=c.getNext();
		}
	}
}
