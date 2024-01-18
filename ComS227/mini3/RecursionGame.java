package mini3;
/**
* <h1>RecursionGame.java</h1>
* <p>
* Recursive method to search for possible arithmetic combinations in a given
* ArrayList inspired by the game twenty four.
* </p>
*
* @author  Neha Maddali
*/

import java.util.ArrayList;

/**
 * Implementation of a search for solutions to a number game inspired
 * by the game "twenty-four".
 */
public class RecursionGame
{
	
	/**
	 * Lists all ways to obtain the given target number using arithmetic operations
	 * on the values in the given IntExpression list.  Results in string form are added to 
	 * the given result list, where the string form of a value is obtained from 
	 * the toString() of the IntExpression object.
	 * <p>
	 * Special rules are: 
	 * 1) you are not required to use all given numbers, and 
	 * 2) division is integer division, and is only allowed when remainder is zero.  
	 * For addition and multiplication, a + b and b + a are considered to be 
	 * distinct solutions, and likewise a * b and b * a are considered as 
	 * different solutions.  See the pdf for detailed examples.
	 * @param list
	 *   the values to be used in forming solutions
	 * @param target
	 *   the target number to be obtained from the values in the list
	 * @param results
	 *   list in which to place results, as strings
	 */
	public static void findCombinations(ArrayList<IntExpression> list, int target, ArrayList<String> results)
	{
		// TODO
		//if the list has size 1 and equals target value, add to results
		if(list.size() == 1) {
			if(list.get(0).getIntValue() == target) {
				results.add(list.get(0).toString());
			}
		}
		else {
			//for each number x in the list create a copy of the list without x
			for(int x = 0; x<list.size(); x++) {
				ArrayList<IntExpression> listCopy = new ArrayList<IntExpression>(list);
				listCopy.remove(listCopy.get(x));
				//find the solutions using that list
				findCombinations(listCopy, target, results);
			}
			//for each pair of numbers x, y in the list and for each allowable 
			//arithmetic combination z of x and y, create a copy of the list with only z
			//find solutions using that list
			for(int y = 0; y<list.size()-1;y++) {
				for(int z = y+1; z<list.size();z++) {
					IntExpression test = new IntExpression(list.get(y), list.get(z), '+');
					ArrayList<IntExpression> copy = new ArrayList<IntExpression>(list);
					copy.remove(copy.get(z));
					copy.remove(copy.get(y));
					copy.add(test);
					findCombinations(copy, target, results);
					
					IntExpression test5 = new IntExpression(list.get(z), list.get(y), '+');
					ArrayList<IntExpression> copy5 = new ArrayList<IntExpression>(list);
					copy5.remove(copy5.get(z));
					copy5.remove(copy5.get(y));
					copy5.add(test5);
					findCombinations(copy5, target, results);
					
					IntExpression test2 = new IntExpression(list.get(y), list.get(z), '-');
					ArrayList<IntExpression> copy2 = new ArrayList<IntExpression>(list);
					copy2.remove(copy2.get(z));
					copy2.remove(copy2.get(y));
					copy2.add(test2);
					findCombinations(copy2, target, results);
					
					IntExpression test7 = new IntExpression(list.get(z), list.get(y), '-');
					ArrayList<IntExpression> copy7 = new ArrayList<IntExpression>(list);
					copy7.remove(copy7.get(z));
					copy7.remove(copy7.get(y));
					copy7.add(test7);
					findCombinations(copy7, target, results);
					
					IntExpression test3 = new IntExpression(list.get(y), list.get(z), '*');
					ArrayList<IntExpression> copy3 = new ArrayList<IntExpression>(list);
					copy3.remove(copy3.get(z));
					copy3.remove(copy3.get(y));
					copy3.add(test3);
					findCombinations(copy3, target, results);
					
					IntExpression test6 = new IntExpression(list.get(z), list.get(y), '*');
					ArrayList<IntExpression> copy6 = new ArrayList<IntExpression>(list);
					copy6.remove(copy6.get(z));
					copy6.remove(copy6.get(y));
					copy6.add(test6);
					findCombinations(copy6, target, results);

					if(list.get(z).getIntValue() != 0 && list.get(y).getIntValue()% list.get(z).getIntValue() == 0) {
						IntExpression test4 = new IntExpression(list.get(y), list.get(z), '/');
						ArrayList<IntExpression> copy4 = new ArrayList<IntExpression>(list);
						copy4.remove(copy4.get(z));
						copy4.remove(copy4.get(y));
						copy4.add(test4);
						findCombinations(copy4, target, results);
					}
					
					if(list.get(y).getIntValue() != 0 && list.get(z).getIntValue()% list.get(y).getIntValue() == 0) {
						IntExpression test8 = new IntExpression(list.get(z), list.get(y), '/');
						ArrayList<IntExpression> copy8 = new ArrayList<IntExpression>(list);
						copy8.remove(copy8.get(z));
						copy8.remove(copy8.get(y));
						copy8.add(test8);
						findCombinations(copy8, target, results);
					}
				}				
			}
		}
	} 
}