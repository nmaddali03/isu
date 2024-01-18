import React from "react";

export const Home = () => {
  return (
    <div style={{ textAlign: "center", marginLeft: "10%", marginRight: "10%", marginBottom:"5%" }}>
      <h1>How to Play Hangman</h1>
      <p>
        The game set up will be a set of dashes/underscores to represent the hidden word.
      </p>{" "}
      <br></br>
      <p>
        There will be set up for the stick figure hangman to be drawn to
        represent the "life” of the game. <br></br>
        You can guess letters by clicking a letter on your physical keyboard.
        For every letter guessed, the keyboard will disable the letter.
      </p>{" "}
      <br></br>
      <p>
        If the guessed letter is a part of the hidden word or phrase, then that
        letter will be appear in its correct location of the set of dashes. If
        the guessed letter is not a part of the hidden word or phrase, then an
        element of the hangman will appear.
      </p>{" "}
      <br></br>
      <p>
        You will continue playing the game until they guess the hidden word or
        until there are no more elements to add to the hangman. If all elements
        of the hangman are added, then you have lost the game, and the hidden
        word or phrase will be revealed. If you guesse the word without adding
        all hangman elements, then you have won.
      </p>{" "}
      <br></br>
      <div>
        <h1>How to Play Minesweeper</h1> <br></br>
        <p>
          You are presented with a board of squares. Some squares contain mines
          (bombs), others don't. If you click on a square containing a bomb, you
          lose. If you manage to click all the squares (without clicking on any
          bombs) or flag all the mines, you win.
        </p>{" "}
        <br></br>
        <p>
          Clicking a square which doesn't have a bomb reveals the number of
          neighbouring squares containing bombs. Use this information plus some
          guess work to avoid the bombs.
        </p>{" "}
        <br></br>
        <p>
          To open a square, point at the square and click on it. To mark a
          square you think is a bomb, point and right-click.
        </p>
      </div>
    </div>
  );
};
