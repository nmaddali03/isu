import React, { useState } from "react";
import { NavLink } from "react-router-dom";
import "../style/NavBar.css";


function NavBar() {
  const [click, setClick] = useState(false);

  const handleClick = () => setClick(!click);
  return (
    <>
      <nav className="navbar">
        <div className="nav-container">
          <NavLink exact to="/" className="nav-logo">
            
          </NavLink>

          <ul className={click ? "nav-menu active" : "nav-menu"}>
            <li className="nav-item">
              <NavLink
                exact
                to="/"
                activeClassName="active"
                className="nav-links"
                onClick={handleClick}
              >
                Home
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink
                exact
                to="/hangman"
                activeClassName="active"
                className="nav-links"
                onClick={handleClick}
              >
                Hangman
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink
                exact
                to="/minesweeper"
                activeClassName="active"
                className="nav-links"
                onClick={handleClick}
              >
                Minesweeper
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink
                exact
                to="/about"
                activeClassName="active"
                className="nav-links"
                onClick={handleClick}
              >
                About
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink
                exact
                to="/crud"
                activeClassName="active"
                className="nav-links"
                onClick={handleClick}
              >
                Crud
              </NavLink>
            </li>

          </ul>
          <div className="nav-icon" onClick={handleClick}>
            {/* <i className={click ? "fas fa-times" : "fas fa-bars"}></i> */}

          </div>
        </div>
      </nav>
    </>
  );
}

export default NavBar;
