package hw3;
import static api.State.EMPTY;
import static api.State.PEARL;

import java.util.ArrayList;
import api.Cell;
import api.Direction;
import api.MoveRecord;
import api.State;
import api.StringUtil;

/**
 * Basic game state and operations for a the puzzle game "Pearls", which
 * is a simplified version of "Quell".
 * @author Neha Maddali
 */
public class Pearls
{
	/**
	 * Two-dimensional array of Cell objects representing the 
	 * grid on which the game is played.
	 */
	private Cell[][] grid;

	/**
	 * Instance of PearlUtil to be used with this game.
	 */
	private PearlUtil util;

	// TODO - any other instance variables you need
	private int score; //keeps track of the player's score in the game
	private int moves; //keeps track of how many moves the player made

	/**
	 * Constructs a game from the given string description.  The conventions
	 * for representing cell states as characters can be found in 
	 * <code>StringUtil</code>.  
	 * @param init
	 *   string array describing initial cell states
	 * @param givenUtil
	 *   PearlUtil instance to use in the <code>move</code> method
	 */
	public Pearls(String[] init, PearlUtil givenUtil)
	{
		grid = StringUtil.createFromStringArray(init);
		util = givenUtil;

		// TODO - any other initialization you need
	}

	/**
	 * Returns the number of columns in the grid.
	 * @return
	 *   width of the grid
	 */
	public int getColumns()
	{
		return grid[0].length;
	}

	/**
	 * Returns the number of rows in the grid.
	 * @return
	 *   height of the grid
	 */
	public int getRows()
	{
		return grid.length;
	}

	/**
	 * Returns the cell at the given row and column.
	 * @param row
	 *   row index for the cell
	 * @param col
	 *   column index for the cell
	 * @return
	 *   cell at given row and column
	 */
	public Cell getCell(int row, int col)
	{
		return grid[row][col];
	}

	/**
	 * Returns true if the game is over, false otherwise.  The game ends when all pearls
	 * are removed from the grid or when the player lands on a cell with spikes.
	 * @return
	 *   true if the game is over, false otherwise
	 */
	public boolean isOver()
	{
		// TODO
		int playerRow = getCurrentRow();
		int playerCol = getCurrentColumn();
		State s = grid[playerRow][playerCol].getState();
		if(countPearls() == 0 || State.isSpikes(s)) {
			return true;
		}
		return false;
	}

	/**
	 * Performs a move along a state sequence in the given direction, updating the score, 
	 * the move count, and all affected cells in the grid.  The method returns an 
	 * array of MoveRecord objects representing the states in original state sequence before 
	 * modification, with their <code>movedTo</code> and <code>disappeared</code>
	 * status set to indicate the cell states' new locations after modification.  
	 * @param dir
	 *   direction of the move
	 * @return
	 *   array of MoveRecord objects describing modified cells
	 */
	public MoveRecord[] move(Direction dir)
	{
		// TODO
		State[] states = getStateSequence(dir); //get the state sequence array
		MoveRecord[] records = new MoveRecord[states.length];
		int playerIndex;
		int countPearls = countPearls();

		for(int i= 0; i<states.length; i++) {
			records[i] = new MoveRecord(states[i], i);
		}
		util.moveBlocks(states, records); //calls moveBlocks [passing in the MoveRecords array]

		//calls movePlayer [passing in the same MoveRecords array]
		playerIndex = util.movePlayer(states, records, dir);
		setStateSequence(states, dir, playerIndex); //sets the updated state sequence and player position
		
		score += Math.abs(countPearls-countPearls()); //update score

		for(int i=0; i<records.length; i++) {
			if(records[i].isMoved()) {
				moves++; //count how many moves have been made
			}
		}
		return records;
	}

	// TODO - everything else...
	/**
	 * Returns the row index for the player's current location.
	 * @return
	 * current row index for the player
	 */
	public int getCurrentRow() {
		for(int row = 0; row<grid.length; row++) {
			for(int column = 0; column<grid[0].length;column++) {
				if(grid[row][column].isPlayerPresent()) {
					return row;
				}
			}
		}
		return -1;
	}

	/**
	 * Returns the column index for the player's current location.
	 * @return
	 * current column index for the player
	 */
	public int getCurrentColumn() {
		for(int row = 0; row<grid.length; row++) {
			for(int column = 0; column<grid[0].length;column++) {
				if(grid[row][column].isPlayerPresent()) {
					return column;
				}
			}
		}
		return -1;
	}

	/**
	 * Helper method returns the next row for a state sequence in the given direction, 
	 * possibly wrapping around. If the flag doPortalJump is true, then the next row will 
	 * be obtained by adding the cell's row offset. (Normally the caller will set this flag 
	 * to true when first landing on a portal, but to false for the second portal of the 
	 * pair.)
	 * @param row
	 *   row for current cell
	 * @param col
	 * 	 column for current cell
	 * @param dir
	 *   direction
	 * @param doPortalJump
	 * 	 true if the next cell should be based on a portal offset in case the current cell 
	 *   is a portal
	 * @return
	 *   next row number in a state sequence
	 */
	public int getNextRow(int row, int col, Direction dir, boolean doPortalJump) {		
		if(doPortalJump == true) {
			return grid[row][col].getRowOffset()+row;
		}
		if(dir == Direction.DOWN) {
			row = (row + 1) % getRows();
		}
		if(dir == Direction.UP) {
			row = (row - 1 + getRows()) % getRows();
		}
		return row;
	}

	/**
	 *Helper method returns the next column for a state sequence in the given 
	 *direction, possibly wrapping around. If the flag doPortalJump is true, then the 
	 *next column will be obtained by adding the cell's column offset. (Normally the caller 
	 *will set this flag to true when first landing on a portal, but to false for the second 
	 *portal of the pair.)
	 * @param row
	 *   row for current cell
	 * @param col
	 * 	 column for current cell
	 * @param dir
	 *   direction
	 * @param doPortalJump
	 * 	 true if the next cell should be based on a portal offset in case the current cell 
	 *   is a portal
	 * @return
	 *   next column number in a state sequence
	 */
	public int getNextColumn(int row, int col, Direction dir, boolean doPortalJump) {
		if(doPortalJump == true) {
			return grid[row][col].getColumnOffset()+col;
		}
		if(dir == Direction.RIGHT) {
			col = (col + 1) % getColumns();
		}

		if(dir == Direction.LEFT) {
			col = (col - 1 + getColumns()) % getColumns();
		}
		return col;
	}

	/**
	 * Finds a valid state sequence in the given direction starting with the player's current 
	 * position and ending with a boundary cell as defined by the method State.isBoundary. 
	 * The actual cell locations are obtained by following getNextRow and getNextColumn in the 
	 * given direction, and the sequence ends when a boundary state is found. A boundary state
	 *  is defined by the method State.isBoundary and is different depending on whether a 
	 *  movable block has been encountered so far in the state sequence (the player can 
	 *  move through open gates and portals, but the movable blocks cannot). It can be 
	 *  assumed that there will eventually be a boundary state (i.e., the grid has no infinite 
	 *  loops). The first element of the returned array corresponds to the cell containing 
	 *  the player, and the last element of the array is the boundary state. This method 
	 *  does not modify the grid or any aspect of the game state.
	 * @param dir
	 *   direction
	 * @param doPortalJump
	 * 	 true if the next cell should be based on a portal offset in case the current cell 
	 *   is a portal
	 * @return
	 *   array of state in the sequence
	 */
	public State[] getStateSequence(Direction dir) {
		int playerRow = getCurrentRow();
		int playerCol = getCurrentColumn();
		State s = grid[playerRow][playerCol].getState();
		ArrayList<State> list = new ArrayList<State>();
		boolean doPortalJump = false;
		int count = 0;

		for(int i = playerRow; i<grid.length; i++) {
			for(int j = playerCol; j<grid[0].length;j++) {
				while(!State.isBoundary(s, State.isMovable(s))) {
					list.add(s);
					//portal check to find true/false for doPortalJump
					if(s == State.PORTAL) {
						doPortalJump = true;
						count++;

						if(count % 2 == 0) {
							doPortalJump = false;
						}
					}					
					int tempRow = getNextRow(playerRow, playerCol, dir, doPortalJump);
					int tempCol = getNextColumn(playerRow, playerCol, dir, doPortalJump);
					playerRow = tempRow;
					playerCol = tempCol;
					s = grid[playerRow][playerCol].getState();
				}
			}
		}
		s = grid[playerRow][playerCol].getState();
		list.add(s);
		return list.toArray(new State[] {});
	}

	/**
	 * Sets the given state sequence and updates the player position. This method effectively 
	 * retraces the steps for creating a state sequence in the given direction, starting with
	 * the player's current position, and updates the grid with the new states. The given 
	 * state sequence can be assumed to be structurally consistent with the existing 
	 * grid, e.g., no portal or wall cells are moved.
	 * @param states 
	 * 	 updated states to replace existing ones in the sequence
	 *   is a portal
	 * @param dir
	 *   direction
	 * @param playerIndex 
	 * 	 index within the array of the player's location
	 */
	public void setStateSequence(State[] states, Direction dir, int playerIndex) {
		int playerRow = getCurrentRow();
		int playerCol = getCurrentColumn();
		State s = grid[playerRow][playerCol].getState();
		boolean doPortalJump = false;
		int count = 0;

		for(int x = 0; x<states.length; x++) {	
			if(s == State.PORTAL) {
				doPortalJump = true;
				count++;
				if(count % 2 == 0) {
					doPortalJump = false;
				}
			}

			int tempRow = getNextRow(playerRow, playerCol, dir, doPortalJump);
			int tempCol = getNextColumn(playerRow, playerCol, dir, doPortalJump);

			if(x == playerIndex) {
				grid[playerRow][playerCol].setPlayerPresent(true);
				break;
			}
			grid[playerRow][playerCol].setPlayerPresent(false);

			if(grid[tempRow][tempCol].getState() == State.WALL) {
				break;
			}
			else {
				grid[playerRow][playerCol].setState(states[x]);
				playerRow = tempRow;
				playerCol = tempCol;
				grid[playerRow][playerCol].setPlayerPresent(true);
				s = grid[playerRow][playerCol].getState();
			}	
		}
	}

	/**
	 * Returns the number of pearls left in the grid.
	 * @return
	 * number of pearls in the grid
	 */
	public int countPearls() {
		int countPearls = 0;
		for(int row = 0; row < getRows(); row++) {
			for(int column = 0; column< getColumns(); column++) {
				if(grid[row][column].getState() == State.PEARL) {
					countPearls++;
				}
			}
		}
		return countPearls;
	}

	/**
	 * Returns the current score (number of pearls disappeared) for this game.
	 * @return
	 * current score
	 */
	public int getScore() {
		return score;
	}

	/**
	 * Returns the current number of moves made in this game.
	 * @return
	 * number of moves made
	 */
	public int getMoves() {
		return moves;
	}

	/**
	 * Returns true if the game is over and the player did not die on spikes.
	 * @return
	 * true if the player wins, false otherwise
	 */
	public boolean won() {
		int playerRow = getCurrentRow();
		int playerCol = getCurrentColumn();
		State s = grid[playerRow][playerCol].getState();
		if(countPearls() == 0 && !State.isSpikes(s)) {
			return true;
		}
		return false;
	}

}
