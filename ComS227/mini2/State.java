package mini2;


/**
 * Possible cell states for a certain puzzle game.
 */
public enum State
{ 
  // WARNING: if we change these, be sure to update the TEXT array too!
  EMPTY, 
  WALL, 
  PEARL, 
  OPEN_GATE, 
  CLOSED_GATE, 
  MOVABLE_POS, 
  MOVABLE_NEG, 
  SPIKES_LEFT, 
  SPIKES_RIGHT, 
  SPIKES_DOWN, 
  SPIKES_UP, 
  SPIKES_ALL, 
  PORTAL;
  

  
  /**
   * Returns true if the given state represents a movable block.
   * @param s
   *   a State value
   * @return
   *   true if the given state is one of the two movable block types
   */
  public static boolean isMovable(State s)
  {
    return s == MOVABLE_POS || s == MOVABLE_NEG;
  }
  
  /**
   * Returns true if both given states are movable and have opposite parity.
   * @param s1
   *   a State value
   * @param s2
   *   a State value
   * @return
   *   true if both given states are movable and have opposite parity
   */
  public static boolean canMerge(State s1, State s2)
  {
    return s1 == MOVABLE_POS && s2 == MOVABLE_NEG ||
           s2 == MOVABLE_POS && s1 == MOVABLE_NEG;
  }
  

  /**
   * Determines whether the given state should be considered a boundary
   * when constructing a state sequence for a move.  The "boundary" 
   * is the last cell in the sequence, beyond which nothing will move.
   * For motion of the player, the possible boundaries are CLOSED_GATE, WALL, 
   * or any form of spikes.  However, movable blocks cannot pass through gates or 
   * portals, so if there were any movable blocks encountered previously
   * in constructing the sequence, then OPEN_GATE and PORTAL would also be 
   * considered boundary states.
   * @param s
   *   any State value
   * @param containsMovable
   *   true if OPEN_GATE and PORTAL should also be treated as boundary states, 
   *   false otherwise
   * @return
   *   true if the given state is a boundary when constructing a state sequence
   */
  public static boolean isBoundary(State s, boolean containsMovable)
  {
    if (!containsMovable)
    {
      return s == CLOSED_GATE ||
          s == SPIKES_LEFT ||
          s == SPIKES_RIGHT ||
          s == SPIKES_DOWN ||
          s == SPIKES_UP ||
          s == SPIKES_ALL ||
          s == WALL;
    }
    else
    {
      return s == CLOSED_GATE ||
          s == SPIKES_LEFT ||
          s == SPIKES_RIGHT ||
          s == SPIKES_DOWN ||
          s == SPIKES_UP ||
          s == SPIKES_ALL ||
          s == WALL ||

          // movable blocks can't go through gates or portals,
          // so these also count as boundary states when
          // there is a movable block
          s == OPEN_GATE ||
          s == PORTAL;
    }
  }
  
  /**
   * Text representation for printing states.
   */
  public static final char[] TEXT = {
    '.',  //  EMPTY, 
    '#', //  WALL, 
    '@', //  PEARL, 
    'o', //  OPEN_GATE, 
    'x', //  CLOSED_GATE, 
    '+', //  MOVABLE_POS, 
    '-', //  MOVABLE_NEG, 
    '<', //  SPIKES_LEFT, 
    '>', //  SPIKES_RIGHT, 
    'v', //  SPIKES_DOWN, 
    '^', //  SPIKES_UP, 
    '*', //  SPIKES_ALL, 
    'O'//  PORTAL;
  };
  
  /**
   * Character to represent a null state in string conversions.
   */
  public static final char NULL_CHAR = 'n';
  
  /**
   * Returns the basic character for a State.  Returns NULL_CHAR if the
   * given state is null.
   * @param s
   *   a State
   * @return
   *   character for the given state
   */
  public static char getChar(State s)
  {
    if (s == null)
    {
      return NULL_CHAR;
    }
    else
    {
      return TEXT[s.ordinal()];
    }
  }
  
  /**
   * Returns the State corresponding to the given character,
   * if possible.  Any capital letter in the range 'A' - 'Z'
   * is treated as a portal.
   * @param c
   *   given character
   * @return
   *   State corresponding to the given character, of null if
   *   the character does not correspond to a State
   */
  public static State getValue(char c)
  {
    int i;
    for (i = 0; i < TEXT.length; ++i)
    {
      if (TEXT[i] == c)
      {
        break;
      }
    }
    if (i < TEXT.length)
    {
      return State.values()[i];
    }
    else if (c >= 'A' && c <= 'Z')
    {
      return State.PORTAL;  
    }
    else return null;
  }
  
  /**
   * Converts a state array to a string representation, using the character
   * representations defined in this class, with an extra space 
   * inserted between characters. A null state will be represented by the 
   * character NULL_CHAR.
   * @param arr
   *   array of State
   * @return
   *   string representation of the State array
   */
  public static String toString(State[] arr)
  {
    return toString(arr, true);
  }
  
  /**
   * Converts a state array to a string representation, using the character
   * representations defined in this class, where an extra space is optionally
   * inserted between characters.  A null state will be represented by the 
   * character NULL_CHAR.
   * @param arr
   *   array of State
   * @param addSpaces
   *   if true, method inserts a space between characters
   * @return
   *   string representation of the State array
   */
  public static String toString(State[] arr, boolean addSpaces)
  {
    String text = "";
    for (int col = 0; col < arr.length; ++col)
    {
      State s = arr[col];
      char ch = getChar(s);
      text += ch;
      if (addSpaces && col < arr.length - 1)
      {
        text += " ";
      }
    }
    return text;
  }


  
}
