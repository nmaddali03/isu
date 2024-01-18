package hw4;

/**
 * Implementation of a binary counter with a fixed number of bits.
 * @author Neha Maddali
 */
public class Counter extends AbstractStatefulComponent {
	/**
	 * current state in the bit
	 */
	private int currentState;
	
	/**
	 * number of bits
	 */
	private int size;
	
	/**
	 * Constructs a counter with the given number of bits.
	 * @param size
	 */
	public Counter(int size) {
		super(0, size);
		this.currentState = 0;
		this.size = size;
		clear();
	}
	
	/**
	 * Updates the internal state, if any, provided that the component is enabled.
	 */
	@Override
	public void tick() {
		if(isEnabled() && inputsValid()) {
			//invalidateOutputs();
			currentState++;
			String binary = Integer.toBinaryString(currentState);
			char x = ' ';
			int num = 0;
			for(int i=0; i<Math.min(binary.length(), size);i++) {
				x = binary.charAt(binary.length()-i-1);
				num = Character.getNumericValue(x);
				outputs()[i].set(num);
			}
		}
	}
}