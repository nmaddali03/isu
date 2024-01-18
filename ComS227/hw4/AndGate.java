package hw4;

/**
 * This class stimulates the and gate 
 * @author Neha Maddali
 */
public class AndGate extends AbstractComponent {
	/**
	 * Constructs an and-gate with two inputs.
	 */
	public AndGate() {
		super(2, 1);
	}

	/**
	 * Propagates inputs to outputs. Does nothing if not all inputs are valid.
	 */
	@Override
	public void propagate() {
		if(inputsValid()) {
			int newValue = 0;
			if(inputs()[0].getValue() == 1 && inputs()[1].getValue() == 1) {
				newValue = 1;
			}
			outputs()[0].set(newValue);
		}
	}
}
