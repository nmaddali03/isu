package hw4;

/**
 * Implementation of a specialized CompoundComponent in which all subcomponents 
 * are identical and have one output.
 * @author Neha Maddali
 */

import api.IComponent;

public class MultiComponent extends CompoundComponent {

	/**
	 * Constructs a MultiComponent with the given array of subcomponents. 
	 * All elements of the array must be identical and must have one output.
	 * @param components - subcomponents for this multicomponent
	 */
	public MultiComponent(IComponent[] components) {
		super(components[0].inputs().length * components.length, components.length);

		invalidateInputs();
		invalidateOutputs();

		int m = 0;
		for(IComponent c: components) {
			addComponent(c);
			for(int i = 0; i<c.inputs().length;i++) {
				inputs()[m*c.inputs().length+i].connectTo(c.inputs()[i]);
			}
			c.outputs()[0].connectTo(outputs()[m]);
			m++;

		}
	}
}
