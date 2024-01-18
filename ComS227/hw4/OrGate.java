package hw4;

/**
 * Implementation of an or-gate with two inputs.
 * @author Neha Maddali
 */
public class OrGate extends AbstractComponent {
	/**
	 * Constructs an or-gate with two inputs.
	 */
	public OrGate() {
		super(2, 1);
	}

	/**
	 * Propagates inputs to outputs. Does nothing if not all inputs are valid.
	 */
	@Override
	public void propagate() {
		int newValue = 0;
		if(inputsValid()) {
			if(inputs()[0].getValue() == 1 || inputs()[1].getValue() == 1) {
				newValue = 1;
			}
			if(inputs()[0].getValue() == 1 && inputs()[1].getValue() == 1) {
				newValue = 0;
			}
			outputs()[0].set(newValue);
		}
	}

}
