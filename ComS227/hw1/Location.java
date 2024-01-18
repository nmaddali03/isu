package hw1;

/**
* <h1>Location.java</h1>
* <p>
* The Location.java program creates a Location object that represents a city/location
* and lodging cost per night. There are several accessor methods and no mutator 
* methods. 
* </p>
*
* @author  Neha Maddali
* @version 1.0
* @since   2020-09-10 
*/

public class Location {
	//cost to mail a postcard from location is 0.05 times the location's lodging cost 
	public static final double RELATIVE_COST_OF_POSTCARD = 0.05;
	
	private String currentLocation;
	private int lodgingCost;
	
	public Location(String givenName, int givenLodgingCost){
		//location of the lodging place
		currentLocation = givenName;
		//cost per night
		lodgingCost = givenLodgingCost;
	}
	
	public String getName(){
		//returns the name of the location
		return currentLocation;
	}
	
	public int lodgingCost() {
		//returns the location's lodging cost per night
		return lodgingCost;
	}
	
	public int costToSendPostcard(){
		//Returns the cost to send a postcard from this location
		return (int) Math.round(lodgingCost * RELATIVE_COST_OF_POSTCARD);
	}
	
	public int maxLengthOfStay(int funds) {
		//Returns the number of affordable nights of lodging in this location 
		return (funds/lodgingCost);
	}
	
	public int maxNumberOfPostcards(int funds) {
		//returns the number of affordable postcards from location
		return (int) (funds/Math.round(lodgingCost * RELATIVE_COST_OF_POSTCARD));
	}
	
}
