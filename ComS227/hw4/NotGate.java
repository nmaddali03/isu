package hw4;

/**
 * Implementation of a not-gate with one input.
 * @author Neha Maddali
 */
public class NotGate extends AbstractComponent {
	/**
	 * Constructs an not-gate with one input.
	 */
	public NotGate() {
		super(1,1);
	}
	
	/**
	 * Propagates inputs to outputs. Does nothing if not all inputs are valid.
	 */
	@Override
	public void propagate() {
		int newValue = 0;
		if(inputsValid()) {
			if(inputs()[0].getValue() == 0) {
				newValue = 1;
			}
			else if(inputs()[0].getValue() == 1) {
				newValue = 0;
			}
			outputs()[0].set(newValue);
		}
	}
}
