package hw1;

/**
* <h1>Backpacker.java</h1>
* <p>
* The Backpacker.java program uses a Backpacker object to model a student traveling
* around Europe with a certain amount of money and a specific location represented
* by the Location object created through the Location.java class. Here there are methods
* that calculate how many nights are affordable in lodging centers and to send postcards
* home. If the backpacker doesn't have enough money for a night, they sleep at the 
* train station. If they send postcards and call home, their parents will add money to
* their account. 
* </p>
*
* @author  Neha Maddali
* @version 1.0
* @since   2020-09-10 
*/

public class Backpacker {
	//Proportional constant when calling home for more money 30 times the number of postcards sent
	//(since the last time she called home for money).
	public static final int SYMPATHY_FACTOR = 30;
		
	private int funds;
	private Location currentLocation;
	private String journal;
	private int actualPostcard;
	private int numNightsTrain;
	
	public Backpacker(int initialFunds, Location initialLocation) {
		funds = initialFunds;
		currentLocation = initialLocation;
		journal = initialLocation.getName() + "(start)";
	}
	
	public String getCurrentLocation() {
		//Returns the name of the backpacker's current location
		return currentLocation.getName();
	}
	
	public int getCurrentFunds() {
		//Returns the amount of money the backpacker currently has.
		return funds;
	}
	
	public String getJournal() {
		//return journal entries
		return journal; 
	}
	
	public boolean isSOL() {
		//Returns true if the backpacker does not have enough money to send a 
		//postcard from the current location.
		return getCurrentFunds() < currentLocation.costToSendPostcard();
	}
	
	public int getTotalNightsInTrainStation() {
		//return number of nights in train station
		return numNightsTrain;
	}
	
	public void visit(Location c, int numNights) {
		currentLocation = c;
		//get the current location lodging cost
		int cost = currentLocation.lodgingCost();
		//find the max number of nights you can stay for the funds you have
		int lodgingNights = currentLocation.maxLengthOfStay(getCurrentFunds());
		//find the actual number of nights you want to stay and calculate the price
		int actualNights = Math.min(lodgingNights, numNights);
		cost = cost * actualNights;
		funds = funds - cost;
		journal += ", " + currentLocation.getName() + "("+numNights+")";
		
		//adds number of nights to sleep at train station
		numNightsTrain += numNights - actualNights;
	}
	
	public void sendPostcardsHome(int howMany) {
		//determine max number of post cards you can send and calculate price
		//apply same logic as in visit method
		int costPostcard = currentLocation.costToSendPostcard();		
		int maxPostcard = currentLocation.maxNumberOfPostcards(getCurrentFunds());
		int numPostcard = Math.min(maxPostcard, howMany);
		costPostcard = costPostcard * numPostcard;
		funds = funds - costPostcard;
		
		//adds number of affordable postcards sent
		actualPostcard += numPostcard;
	}
	
	public void callHomeForMoney() {		
		//calculate the funds after giving a call home		
		funds = funds + (actualPostcard * SYMPATHY_FACTOR);
		actualPostcard = 0; //set sent post cards back to zero
	}
	
}
