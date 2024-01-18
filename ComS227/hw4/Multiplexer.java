package hw4;

/**
 * Implementation of a single-output multiplexer.
 * @author Neha Maddali
 */
import api.Util;

public class Multiplexer extends AbstractComponent {
	/**
	 * selection bit
	 */
	private int selected;
	
	/**
	 * number of selection bits
	 */
	private int k;
	
	/**
	 * Constructs a multiplexer that uses k bits to select from one of 2^k inputs. 
	 * The total number of inputs is 2^k + k, where the last k inputs are interpreted 
	 * as a binary number to select one of the first 2^k inputs to be the output value.
	 * @param k - number of selection bits
	 */
	public Multiplexer(int k) {
		super((int)(Math.pow(2, k))+k, 1);
		this.k = k;
	}

	/**
	 * Propagates inputs to outputs. Does nothing if not all inputs are valid.
	 */
	@Override
	public void propagate() {
		selected = Util.toIntValue(inputs(),(int)(Math.pow(2, k)),inputs().length);

		outputs()[0].set(inputs()[selected].getValue());		
	}

}
