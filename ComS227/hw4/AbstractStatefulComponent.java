package hw4;

/**
 * Abstract supertype for stateful components.
 * @author Neha Maddali
 */
import api.IStatefulComponent;
import api.Pin;

public abstract class AbstractStatefulComponent extends AbstractComponent implements IStatefulComponent
{
	/**
	 * outputs for this component
	 */
	private Pin[] outputs;
	
	/**
	 * boolean to check if pin is enabled
	 */
	private boolean isEnabled;
	
	/**
	 * constructs an abstract stateful component
	 * @param i -- number of inputs
	 * @param o -- number of outputs
	 */
	protected AbstractStatefulComponent(int i, int o) {
		super(i, o);
	}

	/**
	 * Changes the state of all outputs to invalid.
	 */
	@Override
	public void invalidateOutputs() {
		for (Pin e : outputs) {
			if(e.isValid()) {
				e.invalidate();
			}
		}
	}
	
	/**
	 * Propagates inputs to outputs. Does nothing if not all inputs are valid.
	 */
	@Override
	public void propagate() {
		for (Pin e : outputs)
	    {
	      e.set(e.getValue());
	    }
	}
	
	/**
	 * Enables or disables updates to the internal state, if any, 
	 * when processing the tick() operation.
	 * @param enabled - whether or not this component should be enabled
	 */
	public void setEnabled(boolean enabled) {
		isEnabled = enabled;
	}
	
	/**
	 * returns whether isEnabled is true or false
	 * @return isEnabled
	 */
	public boolean isEnabled() {
        return  isEnabled;
    }
	
	/**
	 * Clears the internal state, if any (sets to all zeros).
	 */
	public void clear() {
		for (int i = 0; i < outputs().length; i++) {
            outputs()[i].set(0);
        }
	}
}
