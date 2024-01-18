package hw4;

/**
 * Implementation of a standard full adder circuit. This version extends 
 * CompoundComponent and uses two instances of HalfAdder as subcomponents.
 * @author Neha Maddali
 */
import api.IComponent;

public class FullAdder extends CompoundComponent{	
	/**
	 * Constructs a new FullAdder.
	 */
	public FullAdder() {
		super(3, 2);
		
		IComponent halfAdder1 = new HalfAdder();
        IComponent halfAdder2 = new HalfAdder();
        IComponent orGate = new OrGate();
        addComponent(halfAdder1);
        addComponent(halfAdder2);
        addComponent(orGate);

        inputs()[0].connectTo(halfAdder1.inputs()[0]);
        inputs()[1].connectTo(halfAdder1.inputs()[1]);
        inputs()[2].connectTo(halfAdder2.inputs()[0]);

        halfAdder1.outputs()[0].connectTo(halfAdder2.inputs()[1]);
        halfAdder1.outputs()[1].connectTo(orGate.inputs()[0]);
        halfAdder2.outputs()[1].connectTo(orGate.inputs()[1]);

        halfAdder2.outputs()[0].connectTo(outputs()[0]);
        orGate.outputs()[0].connectTo(outputs()[1]);
		
	}

}