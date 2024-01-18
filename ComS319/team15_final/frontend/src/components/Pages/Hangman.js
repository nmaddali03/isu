import React, { useState, useEffect } from 'react';
import Header from '../Header';
import Figure from '../Figure';
import WrongLetters from '../WrongLetters';
import Word from '../Word';
import Popup from '../Popup';
import Notification from '../Notification';
import { showNotification as show, checkWin } from '../helpers';

import '../../style/Hangman.css';

function App() {
  const [playable, setPlayable] = useState(true);
  const [correctLetters, setCorrectLetters] = useState([]);
  const [wrongLetters, setWrongLetters] = useState([]);
  const [showNotification, setShowNotification] = useState(false);
  const [selectedWord, setSelectedWord] = useState('');

  useEffect(() => {
    // Fetch a word from the database when the component mounts
    fetchWord();
  }, []);

  useEffect(() => {
    const handleKeydown = (event) => {
      const { key, keyCode } = event;

      if (document.activeElement.tagName === 'INPUT') {
        return;
      }

      if (playable && keyCode >= 65 && keyCode <= 90) {
        const letter = key.toLowerCase();
        if (selectedWord.includes(letter)) {
          if (!correctLetters.includes(letter)) {
            setCorrectLetters((currentLetters) => [...currentLetters, letter]);
          } else {
            show(setShowNotification);
          }
        } else {
          if (!wrongLetters.includes(letter)) {
            setWrongLetters((currentLetters) => [...currentLetters, letter]);
          } else {
            show(setShowNotification);
          }
        }
      }
    };

    window.addEventListener('keydown', handleKeydown);

    return () => window.removeEventListener('keydown', handleKeydown);
  }, [correctLetters, wrongLetters, playable, selectedWord]);

  function playAgain() {
    setPlayable(true);

    // Empty Arrays
    setCorrectLetters([]);
    setWrongLetters([]);

    // Fetch a new word from the database
    fetchWord();
  }

  async function fetchWord() {
    try {
      const response = await fetch('http://localhost:8081/listWords');
      const data = await response.json();
      if (data.length > 0) {
        const randomIndex = Math.floor(Math.random() * data.length);
        setSelectedWord(data[randomIndex].word);
      }
    } catch (error) {
      console.error('Error fetching word:', error);
    }
  }

  return (
    <>
      <Header />
      <div className="game-container">
        <Figure wrongLetters={wrongLetters} />
        <WrongLetters wrongLetters={wrongLetters} />
        <Word selectedWord={selectedWord} correctLetters={correctLetters} />
      </div>
      <Popup
        correctLetters={correctLetters}
        wrongLetters={wrongLetters}
        selectedWord={selectedWord}
        setPlayable={setPlayable}
        playAgain={playAgain}
      />
      <Notification showNotification={showNotification} />
    </>
  );
}

export default App;