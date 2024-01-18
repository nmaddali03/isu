package hw4;

/**
 * Implementation of IComponent that contains other components. Clients are 
 * responsible for adding the subcomponents using the addComponent() method and for 
 * creating all internal connections between components. This class is not designed to 
 * be used for stateful components.
 * @author Neha Maddali
 */
import api.IComponent;
import java.util.ArrayList;

public class CompoundComponent extends AbstractComponent {
	private ArrayList<IComponent> components;
	
	/**
	 * Constructs a CompoundComponent with the given number of inputs and number of outputs.
	 */
	public CompoundComponent(int i, int o) {
		super(i, o);
		invalidateInputs();
		invalidateOutputs();
		components = new ArrayList<>();
	}
	
	/**
	 * Adds the given component to the list of subcomponents.
	 * @param c - component to be added
	 */
	public void addComponent(IComponent c) {
		components.add(c);
	}
	
	/**
	 * Returns a reference to the list of subcomponents.
	 * @return the list of subcomponents.
	 */
	public ArrayList<IComponent> getComponents(){
		return components;
	}

	/**
	 * Propagates inputs to outputs. Does nothing if not all inputs are valid.
	 */
	@Override
	public void propagate() {
		while(true) {
			for(IComponent c: components) {
				if(c.inputsValid()) {
					c.propagate();
				}
			}
			if(this.outputsValid()) {
				break;
			}
		}
	}

}
