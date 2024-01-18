package hw2;

/**
 * This class models a Card Dispenser with a clock to get the time
 * 
 * @author Neha Maddali
 */

public class CardDispenser {
	/**
	   * cd object of TimeClock
	   */
	private TimeClock cd;
	
	/**
	   * Constructs a CardDispenser that uses the given clock
	   * @param givenClock
	   */
	public CardDispenser(TimeClock givenClock) {
		cd = givenClock;
	}
	
	/**
	   * Returns the pc ParkingCard with the time
	   * @return
	   *   pc ParkingCard object
	   */
	public ParkingCard takeCard() {
		ParkingCard pc = new ParkingCard(cd.getTime());
		return pc;		
	}
}
