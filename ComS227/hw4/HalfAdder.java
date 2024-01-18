package hw4;

/**
 * Implementation of a standard half adder circuit. This version extends CompoundComponent.
 * @author Neha Maddali
 */

import api.IComponent;

public class HalfAdder extends CompoundComponent {
	
	/**
	 * Constructs a new HalfAdder.
	 */
	public HalfAdder() {
		super(2, 2);
		
		// create the contained components and add them to the list
		IComponent andGate = new AndGate();
		IComponent andGate2 = new AndGate();
		IComponent orGate = new OrGate();
		IComponent notGate = new NotGate();
		addComponent(andGate);
		addComponent(andGate2);
		addComponent(orGate);
		addComponent(notGate);
		
		// wire inputs
		inputs()[0].connectTo(andGate.inputs()[0]);
		inputs()[1].connectTo(andGate.inputs()[1]);
		inputs()[0].connectTo(orGate.inputs()[0]);
		inputs()[1].connectTo(orGate.inputs()[1]);
		
		// wiring to compute (A or B) and (not (A and B))
		orGate.outputs()[0].connectTo(andGate2.inputs()[0]);
		andGate.outputs()[0].connectTo(notGate.inputs()[0]);
		notGate.outputs()[0].connectTo(andGate2.inputs()[1]);
		
		// wire outputs:
		// output[0] is the "sum", which is the output of second and-gate
		andGate2.outputs()[0].connectTo(outputs()[0]);
		
		// output[1] is the "carry", output of first and-gate
		andGate.outputs()[0].connectTo(outputs()[1]);
	}	

}
