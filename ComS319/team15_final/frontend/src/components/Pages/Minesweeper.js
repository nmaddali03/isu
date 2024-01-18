import React from 'react';
import ReactDOM from 'react-dom';
import Board from '../Board.js';
// import './Minesweeper.css';
import "../../style/Minesweeper.css";

class Minesweeper extends React.Component {

    /*
    Beginner: 10 mines, 8x8 board
    Intermediate: 20 mines, 12x12 board
    Expert: 40 mines, 16x16 board
    */
    state = {
        height: 8,
        width: 8,
        mines: 10,
    };

    handleGameStart = () => {
        let difficulty = document.querySelector("#level_select");
        if (difficulty.value === "beginner") {
            this.setState({
                height: 8,
                width: 8,
                mines: 10,
            });
        }
        if (difficulty.value === "intermediate") {
            this.setState({
                height: 12,
                width: 12,
                mines: 20,
            });
        }
        if (difficulty.value === "expert") {
            this.setState({
                height: 16,
                width: 16,
                mines: 40,
            });
        }
    }

    render() {
        const { height, width, mines } = this.state;
        return (
            <div className="game">
                <div className="game-info">
                    
                    <h4>Select a level a click "start"</h4>
                    <span className="info">Level:
                        <select id="level_select">
                            <option value="beginner"> Beginner </option>
                            <option value="intermediate"> Intermediate </option>
                            <option value="expert"> Expert </option>
                        </select>
                    </span>
                    <button onClick={this.handleGameStart}>Start</button>
                </div>

                <Board height={height} width={width} mines={mines} />
                
            </div>
        );
    }
}

ReactDOM.render(<Minesweeper />, document.getElementById('root'));
export default Minesweeper;