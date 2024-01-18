package hw4;

/**
 * Abstract supertype with common code for all components.
 * 
 * @author Neha Maddali
 */

import api.IComponent;
import api.Pin;

public abstract class AbstractComponent implements IComponent {	
	/**
	 * Outputs for this component.
	 */
	private Pin[] outputs;

	/**
	 * Inputs for this component.
	 */
	private Pin[] inputs;
	
	/**
	 * constructs an abstract component		
	 * @param i -- number of inputs
	 * @param o -- number of outputs
	 */
	protected AbstractComponent(int i, int o){
		inputs = new Pin[i];
		outputs = new Pin[o];
		
		for(int j = 0; j<inputs.length; j++) {
			inputs[j] = new Pin(this);
		}
		for(int x = 0; x<outputs.length;x++) {
			outputs[x] = new Pin(this);
		}
	}
	
	/**
	 * Changes the state of all inputs to invalid.
	 */
	@Override
	public void invalidateInputs() {
		for (Pin e : inputs) e.invalidate();		
	}

	/**
	 * Changes the state of all outputs to invalid.
	 */
	@Override
	public void invalidateOutputs() {
		for (Pin e : outputs) e.invalidate();
	}

	/**
	 * Returns whether all inputs are valid.
	 * @return
	 *   true if all inputs are valid, false otherwise
	 */
	@Override
	public boolean inputsValid() {
		for (Pin e : inputs)
		{
			if (!e.isValid()) return false;
		}
		return true;
	}

	/**
	 * Returns whether all outputs are valid.
	 * @return
	 *   true if all outputs are valid, false otherwise
	 */ 
	@Override
	public boolean outputsValid() {
		for (Pin e : outputs)
		{
			if (!e.isValid()) return false;
		}
		return true;
	}

	/**
	 * Returns the array of Pins representing this component's inputs.
	 * @return
	 *   array of input Pins
	 */
	@Override
	public Pin[] inputs() {
		return inputs;
	}

	/**
	 * Returns the array of Pins representing this component's outputs.
	 * @return
	 *   array of output Pins
	 */
	@Override
	public Pin[] outputs() {
		return outputs;
	}
	
}
