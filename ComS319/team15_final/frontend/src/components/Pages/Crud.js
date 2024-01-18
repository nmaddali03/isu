import React, { useState, useEffect } from 'react';
import '../../style/Crud.css';

function Crud() {
  const [newWord, setNewWord] = useState('');
  const [wordToDelete, setWordToDelete] = useState('');
  const [wordList, setWordList] = useState([]);
  const [showList, setShowList] = useState(false);

  useEffect(() => {
    fetchWord();
  }, []);

  async function fetchWord() {
    try {
      console.log('Fetching words...');
      const response = await fetch('http://localhost:8081/listWords');
      const data = await response.json();
      console.log('Fetched data:', data);
      setWordList(data);
    } catch (error) {
      console.error('Error fetching words:', error);
    }
  }

  async function addWord() {
    try {
      const response = await fetch('http://localhost:8081/listWords', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ word: newWord }),
      });

      if (response.ok) {
        const data = await response.json();
        console.log('Added word:', data);
        fetchWord();
        setNewWord('');
      } else {
        console.error('Failed to add word. Status:', response.status);
      }
    } catch (error) {
      console.error('Error adding word:', error);
    }
  }

  async function deleteWord() {
    try {
      const response = await fetch(`http://localhost:8081/listWords/${wordToDelete}`, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({word: wordToDelete}),
      });
  
      if (response.ok) {
        console.log('Word deleted successfully');
        fetchWord();
        setWordToDelete('');
      } else {
        const errorData = await response.json();
        console.error('Failed to delete word. Error:', errorData.error);
      }
    } catch (error) {
      console.error('Error deleting word:', error);
    }
  }
      
  function showWordList() {
    setShowList((prevShowList) => !prevShowList);
  }

  return (
    <div className="container">
      <h1 className="title">CRUD - Hangman Word Management</h1>
      <section className="formSection">
        <button onClick={showWordList} className="button showListButton">
          Show Word List
        </button>
      </section>

      {showList && (
        <div>
          <h3 className="wordList">Word List</h3>
          <div className="wordList">
            {wordList.map((word) => (
              <div key={word._id} className="listItem">
                {word.word}
              </div>
            ))}
          </div>
        </div>
      )}

      <section className="formSection">
        <label htmlFor="newWord">New Word: </label>
        <input
          type="text"
          id="newWord"
          value={newWord}
          onChange={(e) => setNewWord(e.target.value)}
          className="inputField"
        />
        <button onClick={addWord} className="button addWordButton">
          Add Word
        </button>
      </section>

      <section className="formSection">
        <label htmlFor="wordToDelete">Word to Delete: </label>
        <input
          type="text"
          id="wordTo aDelete"
          value={wordToDelete}
          onChange={(e) => setWordToDelete(e.target.value)}
          className="inputField"
        />
        <button onClick={deleteWord} className="button deleteWordButton">
          Delete Word
        </button>
      </section>
    </div>
  );
}

export default Crud;
