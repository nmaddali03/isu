package hw4;

/**
 * Implementation of a register with an internal "state" consisting of a 
 * fixed number of bits.
 * @author Neha Maddali
 */

public class Register extends AbstractStatefulComponent{
	/**
	 * Constructs a register whose state consists of the given number of bits.
	 * @param size
	 */
	public Register(int size) {
		super(size, size);
		clear();
	}
	
	/**
	 * Updates the internal state, if any, provided that the component is enabled.
	 */
	@Override
	public void tick() {
		int[] currentState = new int[inputs().length];
		
		if(isEnabled() && inputsValid()) {
			for(int i = 0; i<inputs().length;i++) {
				currentState[i] = inputs()[i].getValue();
			}
			for(int j=0; j<outputs().length;j++) {
				outputs()[j].set(currentState[j]);
			}
		}
	}
}