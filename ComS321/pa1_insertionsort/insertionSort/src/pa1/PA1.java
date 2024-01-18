package pa1;

import java.util.Scanner;

public class PA1 {
	public final static Scanner scan = new Scanner(System.in);

	public static void main(String[] args) {
		int length;
		System.out.print("enter size of array: ");
		length = scan.nextInt();
		int[] addr = new int[length];
		fill(addr, length);
		printArray(addr, length);
		insertionSort(addr, length);
		printArray(addr, length);
	}
	
	public static void fill(int[] addr, int length) {
		int i = length;
		int j = length;
		for(i = 0, j=length; i<length; i++, j--) {
			addr[i]=j;
		}
	}
	/*
	 *  // X0 = addr
		// X1 = length
		fill:
			SUB X9, X1, XZR
			//if X1 = 0, end
			CBZ X9, end_fill
			STUR X1, [X0, #0]
			SUBI X1, X1, #1
			ADDI X0, X0, #8
			B fill
		end_fill:
			BR LR
	 */
	
	public static void shiftRight(int[] addr, int pos, int finalF) {
		for(int i = finalF-1; i>= pos; i--) {
			addr[i+1] = addr[i];
		}
	}
	
	/*
	 *  // X5 = addr
		// X7 = pos
		// X2 = final
		shiftRight:
			LDUR X7, [SP, #32] // load X7
			LDUR X5, [SP, #8] // load X5
			SUBI X14, X2, #1 // X14 = final - 1 (i)
		shiftRightLoop:
			SUB X14, X14, X7
			ADDI X15, X14, #1
			// if i + 1 = pos, end loop
			CBZ X15, end_shift_right_loop
			// else
			ADD X14, X14, X7
			LSL X13, X14, #3
			ADD X13, X13, X5
			LDUR X12, [X13, #0] // X21 = addr[i]
			ADDI X13, X13, #8
			STUR X12, [X13, #0] // addr[i + 1] = addr[i]
			SUBI X14, X14, #1
			B shiftRightLoop
		end_shift_right_loop:
			STUR X5, [SP, #8] // store X5
			STUR X7, [SP, #32] // store X7
			BR LR	
	 */
	
	public static int findSortedPos(int[] addr, int val, int finalF) {
		int i;
		for(i = 0; i < finalF; i++) {
			if(addr[i] >= val) {
				break;
			}
		}
		return i;
	}
	
	/*
	 *  //X5 = addr
	    //X1 = val
	    //X2 = final
	    findSortedPos:
	   		ADD X0, XZR, XZR //zero out X0 to prepare for a return
	   		LDUR X5, [SP, #8]
	   		LDUR X2, [SP, #24]
	    findSortedPosLoop:
	    	LSL X11, X0, #3
	    	ADD X11, X11, X5
	    	LDUR X11, [X11, #0] //X11 = addr[i]
	    	//if addr[i] >= val, break out loop and return i
	    	SUBS X11, X11, X1
	    	BGE end_find_pos_loop
	    	//if i = final, break out loop and return i
	    	SUB X12, X2, X0
	    	CBZ X12, end_find_pos_loop
	    	//else continue the loop
	    	ADDI X0, X0, #1
	    	B findSortedPosLoop
	    end_find_pos_loop:
	    	STUR X5, [SP, #8] //store X5
	    	STUR X2, [SP, #24] //store X2
	    	BR LR
	 */
	
	public static void insertSortedPos(int[] addr, int pos, int finalV) {
		int v = addr[pos];
		int p = findSortedPos(addr, v, pos);
		shiftRight(addr, p, pos);
		addr[p] = v;
	}
	/*
	 *  // X5 = addr
		// X6 = pos
		// X2 = final
		insertSortedPos:
			LDUR X6, [SP, #0] // load X6
			LSL X9, X6, #3
			ADD X9, X5, X9 // X9 = &addr[i]
			LDUR X10, [X9, #0] // X10 = addr[i] = v
			SUBI SP, SP, #40 // make space
			STUR X6, [SP, #0] // store X6
			STUR X5, [SP, #8] // store X5
			STUR X1, [SP, #16] // store X1
			STUR X2, [SP, #24] // store X2
			ADDI X1, X10, #0 // X1 = v
			BL findSortedPos
			ADDI X11, X0, #0 // X11 = p (from return value in X0)
			LDUR X1, [SP, #16] // get back X1
			ADDI X7, X11, #0 // X7 = p
			STUR X7, [SP, #32] // store X7
			STUR X11, [SP, #40] // store X11
			LDUR X2, [SP, #0]
			BL shiftRight
	 */
	
	public static void insertionSort(int[] addr, int length) {
		for(int i = 1; i < length; i++) {
			insertSortedPos(addr, i, length - 1);
		}
	}
	
	public static void printArray(int[] addr, int length) {
		int i = 0;
		System.out.println("\nArray Data: ");
		for(i = 0; i < length; i++) {
			System.out.print(addr[i] + " ");
		}
	}	
}
