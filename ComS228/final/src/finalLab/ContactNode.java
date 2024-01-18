package finalLab;

public class ContactNode{
   private String contactName;
   private String contactPhoneNumber;
   private ContactNode nextNodePtr;
   
   public ContactNode(String name, String phoneNumber){
      contactName = name;
      contactPhoneNumber = phoneNumber;
   }
   
   public String getName(){
      return contactName;
   }
   
   public String getPhoneNumber(){
      return contactPhoneNumber;
   }
   
   public void insertAfter(ContactNode nextNode){
	   ContactNode temp;
	   temp = nextNodePtr;
	   if(nextNodePtr == null) {
		   nextNodePtr = nextNode;
	   }
	   else {
		   while(temp.getNext() != null) {
			   temp = temp.getNext();
		   }
		   temp.nextNodePtr = nextNode;
	   }
	   return;
   }
   
   public ContactNode getNext(){
	   return nextNodePtr;
   }
   
   public void printContactNode(){
      System.out.println("Name: "+contactName);
      System.out.println("Phone number: "+contactPhoneNumber);
      System.out.println();
   }
}