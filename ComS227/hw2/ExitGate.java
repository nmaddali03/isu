package hw2;

/**
 * This class models an Exit Gate giving the user 15 minutes to grab their car
 * after they pay and leave the garage to receive a successful exit.
 * 
 * @author Neha Maddali
 */

public class ExitGate {
	
	/**
	   * The number of exits made
	   */
	private int exitCount;
	
	/**
	   * clock object of TimeClock
	   */
	private TimeClock clock;
	
	//Constructs an ExitGate that uses the given clock and has an initial count of zero.
	/**
	   * Constructs a ExitGate that uses the given clock. Initially, exitCounts 
	   * equal zero
	   * @param givenClock
	   */
	public ExitGate (TimeClock givenClock) {
		clock = givenClock;
		exitCount = 0;
	}
	
	/**
	   * Returns boolean based on user's payment time in within the exit time limit
	   * @return
	   *   true or false
	   */
	public boolean insertCard(ParkingCard c) {
		int exitTime = RateUtil.EXIT_TIME_LIMIT;
		if(c.getPaymentTime() == 0) {
			return false;
		}
		else if(Math.max(clock.getTime()-c.getPaymentTime(), exitTime) <= exitTime) {
			exitCount = exitCount + 1;
			return true;
		}
		else {
			return false;
		}
	}
	
	/**
	   * Returns successful exits
	   * @return
	   *   exitCount
	   */
	public int getExitCount() {
		return exitCount;
	}

}
