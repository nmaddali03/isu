package hw2;

/**
 * This class models a pay station that uses a clock from the TimeClock class and 
 * a parking card from the ParkingCard class. The payment is calculated through inserting
 * and ejected the card.
 * 
 * @author Neha Maddali
 */

public class PayStation {
	/**
	   * clock object of TimeClock
	   */
	private TimeClock clock;
	/**
	   * the total payment the user owes the pay station
	   */
	private double totalPayment;
	/**
	   * The time at which the payment is made
	   */
	private int paymentTime;
	/**
	   * pc object of ParkingCard
	   */
	private ParkingCard pc;
	/**
	   * boolean to keep track of whether the pc card is in the pay station or not
	   */
	private boolean inProgress;
	
	/**
	   * Constructs a PayStation that uses the given clock. Initially, total payments 
	   * equal zero
	   * @param givenClock
	   */
	public PayStation(TimeClock givenClock) {
		clock = givenClock;
	}
	
	/**
	   * Sets the boolean inProgress to true to indicate card is in pay station
	   * @param t
	   *   pc ParkingCard to be set
	   */
	public void insertCard(ParkingCard t) {
		pc = t;
		inProgress = true;
	}
	
	/**
	   * Returns the pc ParkingCard
	   * @return
	   *   null if card is not in pay station and return pc if it is
	   */
	public ParkingCard getCurrentCard() {
		if(inProgress == false) {
			return null;
		}
		else {
			return pc;
		}
	}
	
	/**
	   * Returns true or false if pc card is in pay station or not
	   * @return
	   *   inProgress for card
	   */
	public boolean inProgress() {
		if(inProgress == true) {
			return true;
		}
		else {
			return false;
		}
	}
	
	/**
	   * Returns the totalPayment for this card.
	   * @return
	   *   totalPayment for the card
	   */
	public double getPaymentDue() {				
		if(inProgress == true) {			
			int current = clock.getTime(); //get current time
			int ticketStart = pc.getStartTime(); //get start time
			int paid = pc.getPaymentTime(); //get payment time
			
			if(paid > 0) {
				paymentTime = paid - ticketStart;
				double pay = RateUtil.calculateCost(paymentTime);
				double clockPay = RateUtil.calculateCost(current);
				totalPayment = clockPay - pay;
			}
			else {
				paymentTime = current - ticketStart;
				totalPayment = RateUtil.calculateCost(paymentTime);
			}
		}
		else {
			totalPayment = 0.0;
		}
		return totalPayment;
	}
	
	/**
	   * Updates the current pc card with totalPayment and paymentTime
	   */
	public void makePayment() {
		if(inProgress == true) {
			totalPayment += getPaymentDue();
			paymentTime = clock.getTime();
			pc.setPaymentTime(paymentTime);
		}
	}
	
	/**
	   * Sets the boolean inProgress to false to indicate card is ejected 
	   */
	public void ejectCard() {
		if(inProgress == true) {
			inProgress = false;
		}
	}
	
	/**
	   * Returns the totalPayment for this card.
	   * @return
	   *   totalPayment for the card
	   */
	public double getTotalPayments() {
		return totalPayment;
	}
}
