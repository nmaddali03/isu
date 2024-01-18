package hw2;

/**
 * This class holds calculations for user's parking payment
 * 
 * @author Neha Maddali
 */

public class RateUtil {
	/**
	   * the time the user has to exit the parking space after a payment
	   */	
	public static final int EXIT_TIME_LIMIT = 15;
	
	private RateUtil() {
	}
	
	/**
	   * Returns the cost of parking for specified minutes
	   * @return
	   *   cost for parking minutes
	   */
	public static double calculateCost(int minutes) {
		double cost = 0; 
		
		if (minutes <= 30) { //30 minutes cost
			cost = 1.00;
		}
		else if (minutes >= 30 & minutes <= 300) { //1 to 5 hours cost
			int hours = (int) Math.ceil(minutes/60.0);
			cost = 2.00 + (hours - 1)*1.50;
		}
		else if (minutes >= 300 & minutes <= 480) { //6 to 8 hours cost
			int hours = (int) Math.ceil(minutes/60.0);
			cost = 8.00 + (hours-5)*1.25;
		}
		else if(minutes >= 480 & minutes <=1440) { //9 to 24 hours cost
			cost = 13.00;
		}
		else if(minutes >= 1440) { //past 24 hours cost
			int hours = (int) Math.ceil(minutes/60.0);
			int days = hours/24;
			int extraHours = hours % 24;
			double costDays = days * 13.00;
			int newMinutes = extraHours * 60;
			
			double addCost = 0;
			
			if (newMinutes <= 30) {
				addCost = costDays + 1.00;
				cost = addCost;
			}
			else if (newMinutes >= 30 & newMinutes <= 300) {
				hours = (int) Math.ceil(newMinutes/60.0);
				addCost = 2.00 + (hours - 1)*1.50 + costDays;
				cost = addCost;
			}
			else if (newMinutes >= 300 & newMinutes <= 480) {
				hours = (int) Math.ceil(newMinutes/60.0);
				addCost = 8.00 + (hours-5)*1.25 + costDays;
				cost = addCost;
			}
			else if(newMinutes >= 480 & newMinutes <=1440) {
				addCost = 13.00 + costDays;
				cost = addCost;
			}
			return cost;
		}
		return cost;
	}

}
