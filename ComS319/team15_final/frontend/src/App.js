import "./style/App.css";
import NavBar from "./components/NavBar";
import { BrowserRouter as Router,  Route, Routes } from "react-router-dom";
import { Home } from "./components/Pages/Home";
//import { Hangman } from "./components/Pages/Hangman";
//import { Minesweeper } from "./components/Pages/Minesweeper";
import Minesweeper from "./components/Pages/Minesweeper";
import Hangman from "./components/Pages/Hangman";
import  Crud  from "./components/Pages/Crud";

import { About } from "./components/Pages/About";

function App() {
  return (
    <>
      <Router>
        <NavBar />

        <div className="pages">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/hangman" element={<Hangman />} />
            <Route path="/minesweeper" element={<Minesweeper />} />
            <Route path="/about" element={<About />} />
            <Route path="/crud" element={<Crud />} />

          </Routes>
        </div>
      </Router>
  </>
  );
}

export default App;
