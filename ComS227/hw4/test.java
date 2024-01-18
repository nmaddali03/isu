package hw4;
import api.IComponent;
import api.Util;

public class test {
	public static void main(String[] args) {
		//AndGate tests
		System.out.println("----------AND GATE TESTS----------");
		System.out.println("AndGate 1000 expected");
		AndGate andGate = new AndGate();
		Util.setInputs(andGate, "11");
		andGate.propagate();
		System.out.print(Util.toString(andGate.outputs()));//expect 1
		Util.setInputs(andGate, "01");
		andGate.propagate();
		System.out.print(Util.toString(andGate.outputs())); //expect 0
		Util.setInputs(andGate, "10");
		andGate.propagate();
		System.out.print(Util.toString(andGate.outputs())); //expect 0
		Util.setInputs(andGate, "00");
		andGate.propagate();
		System.out.println(Util.toString(andGate.outputs())); //expect 0

		//OrGate tests
		System.out.println("----------OR GATE TESTS----------");
		System.out.println("OrGate 0110 expected");
		OrGate orGate = new OrGate();
		Util.setInputs(orGate, "11");
		orGate.propagate();
		System.out.print(Util.toString(orGate.outputs()));//expect 0
		Util.setInputs(orGate, "01");
		orGate.propagate();
		System.out.print(Util.toString(orGate.outputs())); //expect 1
		Util.setInputs(orGate, "10");
		orGate.propagate();
		System.out.print(Util.toString(orGate.outputs())); //expect 1
		Util.setInputs(orGate, "00");
		orGate.propagate();
		System.out.println(Util.toString(orGate.outputs())); //expect 0

		/*NotGate tests*/  
		System.out.println("----------NOT GATE TESTS----------");
		System.out.println("NotGate 10 expected");
		NotGate notGate = new NotGate();
		Util.setInputs(notGate, "0");
		notGate.propagate();
		System.out.print(Util.toString(notGate.outputs()));//expect 1
		Util.setInputs(notGate, "1");
		notGate.propagate();
		System.out.println(Util.toString(notGate.outputs())); //expect 0

		/*HalfAdder tests*/
		System.out.println("----------HALF ADDER TESTS----------");
		IComponent adder = new HalfAdder();
		Util.setInputs(adder, "01");
		adder.propagate();
		System.out.println("input:" + Util.toString(adder.inputs()));
		System.out.println(Util.toString(adder.outputs()) + ": Expected 01");

		IComponent adder1 = new HalfAdder();
		Util.setInputs(adder1, "10");
		adder1.propagate();
		System.out.println("input:" + Util.toString(adder1.inputs()));
		System.out.println(Util.toString(adder1.outputs()) + ": Expected 01");

		IComponent adder2 = new HalfAdder();
		Util.setInputs(adder2, "11");
		adder2.propagate();
		System.out.println("input:" + Util.toString(adder2.inputs()));
		System.out.println(Util.toString(adder2.outputs()) + ": Expected 10");

		IComponent adder3 = new HalfAdder();
		Util.setInputs(adder3, "00");
		adder3.propagate();
		System.out.println("input:" + Util.toString(adder3.inputs()));
		System.out.println(Util.toString(adder3.outputs()) + ": Expected 00");

		/*FullAdder tests*/
		System.out.println("----------FULL ADDER TESTS----------");
		IComponent fullAdder = new FullAdder();
		Util.setInputs(fullAdder, "010");
		fullAdder.propagate();
		System.out.println("input:" + Util.toString(fullAdder.inputs()));
		System.out.println(Util.toString(fullAdder.outputs()) + ": Expected 01");

		IComponent fullAdder1 = new FullAdder();
		Util.setInputs(fullAdder1, "111");
		fullAdder1.propagate();
		System.out.println("input:" + Util.toString(fullAdder1.inputs()));
		System.out.println(Util.toString(fullAdder1.outputs()) + ": Expected 11");

		IComponent fullAdder2 = new FullAdder();
		Util.setInputs(fullAdder2, "110");
		fullAdder2.propagate();
		System.out.println("input:" + Util.toString(fullAdder2.inputs()));
		System.out.println(Util.toString(fullAdder2.outputs()) + ": Expected 10");

		IComponent fullAdder3 = new FullAdder();
		Util.setInputs(fullAdder3, "101");
		fullAdder3.propagate();
		System.out.println("input:" + Util.toString(fullAdder3.inputs()));
		System.out.println(Util.toString(fullAdder3.outputs()) + ": Expected 10");

		IComponent fullAdder4 = new FullAdder();
		Util.setInputs(fullAdder4, "100");
		fullAdder4.propagate();
		System.out.println("input:" + Util.toString(fullAdder4.inputs()));
		System.out.println(Util.toString(fullAdder4.outputs()) + ": Expected 01");

		IComponent fullAdder5 = new FullAdder();
		Util.setInputs(fullAdder5, "011");
		fullAdder5.propagate();
		System.out.println("input:" + Util.toString(fullAdder5.inputs()));
		System.out.println(Util.toString(fullAdder5.outputs()) + ": Expected 10");

		IComponent fullAdder6 = new FullAdder();
		Util.setInputs(fullAdder6, "001");
		fullAdder6.propagate();
		System.out.println("input:" + Util.toString(fullAdder6.inputs()));
		System.out.println(Util.toString(fullAdder6.outputs()) + ": Expected 01");

		IComponent fullAdder7 = new FullAdder();
		Util.setInputs(fullAdder7, "000");
		fullAdder7.propagate();
		System.out.println("input:" + Util.toString(fullAdder7.inputs()));
		System.out.println(Util.toString(fullAdder7.outputs()) + ": Expected 00");

		/*Multicomponent tests*/
		System.out.println("----------MULTICOMPONENT TESTS----------");
		System.out.println("MultiComponent");
		IComponent A = new AndGate();
		IComponent B = new AndGate();
		IComponent C = new AndGate();
		IComponent[] list = {A, B, C};
		IComponent multiComponent = new MultiComponent(list);
		Util.setInputs(multiComponent, "111011");
		multiComponent.propagate();
		System.out.println(Util.toString(multiComponent.outputs()) + ": Expected 101");

		/*Multiplexer tests*/
		System.out.println("----------MULTIPLEXER TESTS----------");
		IComponent m = new Multiplexer(3);
		Util.setInputs(m, "11001000000"); // Expecting 1, since 011 is 6, index 5 is one.
		//System.out.println(Util.toString(m.inputs())); //for debugging purposes only
		m.propagate();
		System.out.println(m.outputs()[0].getValue() + ": Expected 1");
		Util.setInputs(m, "10100100000"); // Expecting 1, since 101 is 5, index 5 is 1.
		m.propagate();
		System.out.println(m.outputs()[0].getValue() + ": Expected 1");
		IComponent mplex2 = new Multiplexer(2);
		Util.setInputs(mplex2, "100010"); // Expecting 0, since 10 is 2, index 2 is 0.
		mplex2.propagate();
		System.out.println(mplex2.outputs()[0].getValue() + ": Expected 0");
		
		/*Register tests*/
		System.out.println("----------REGISTER TESTS----------");
		Register reg = new Register(3);
		Util.setInputs(reg, "011");
		reg.setEnabled(true);
		reg.tick();
		System.out.println(Util.toString(reg.outputs())); //011
		reg.setEnabled(false);
		Util.setInputs(reg, "100");
		reg.tick();
		System.out.println(Util.toString(reg.outputs())); //011
		reg.setEnabled(true);
		reg.tick();
		System.out.println(Util.toString(reg.outputs())); //100
		reg.clear();
		System.out.println(Util.toString(reg.outputs())); //000

		/*Counter tests*/
		System.out.println("----------COUNTER TESTS----------");
		Counter counter = new Counter(2);
		counter.clear();
		System.out.println(Util.toString(counter.outputs())); // expected "00"
		counter.setEnabled(true);
		counter.tick();
		System.out.println(Util.toString(counter.outputs())); // expected "01"
		counter.tick();
		System.out.println(Util.toString(counter.outputs())); // expected "10"
		counter.tick();
		System.out.println(Util.toString(counter.outputs())); // expected "11"
		counter.tick();
		System.out.println(Util.toString(counter.outputs())); // expected "00"
		counter.setEnabled(false);
		counter.tick();
		System.out.println(Util.toString(counter.outputs())); // expected "00"
	}
}
