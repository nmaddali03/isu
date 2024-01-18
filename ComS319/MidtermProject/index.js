// Initial References
const letterContainer = document.getElementById("letter-container");
const optionsContainer = document.getElementById("options-container");
const userInputSection = document.getElementById("user-input-section");
const newGameContainer = document.getElementById("new-game-container");
const newGameButton = document.getElementById("new-game-button");
const canvas = document.getElementById("canvas");
const resultText = document.getElementById("result-text");

// Options values for buttons
let options = {
  easy: "./easy.json",
  medium: "./medium.json",
  difficult: "./difficult.json",
};

async function fetchOptionsFromJSON(jsonFileName) {
  const response = await fetch(jsonFileName);
  const data = await response.json();
  return data;
}

// Count
let winCount = 0;
let count = 0;

let chosenWord = "";

// Display option buttons
const displayOptions = () => {
  optionsContainer.innerHTML += `<h3>Please Select An Option</h3>`;
  let buttonCon = document.createElement("div");
  for (let value in options) {
    buttonCon.innerHTML += `<button class="options" onclick="generateWord('${value}')">${value}</button>`;
  }
  optionsContainer.appendChild(buttonCon);
};

// Block all the Buttons
const blocker = () => {
  let optionsButtons = document.querySelectorAll(".options");
  let letterButtons = document.querySelectorAll(".letters");
  // Disable all options
  optionsButtons.forEach((button) => {
    button.disabled = true;
  });

  // Disable all letters
  letterButtons.forEach((button) => {
    button.disabled = true; // Fixed the typo here, "button.disabled.true" should be "button.disabled = true"
  });
  newGameContainer.classList.remove("hide");
};

// Define an array to keep track of disabled letters
const disabledLetters = [];

// Common function to handle user input
const handleUserInput = (input) => {
  if (chosenWord) {
    const charArray = chosenWord.split("");
    const dashes = document.getElementsByClassName("dashes");
    const letterButtons = document.querySelectorAll(".letters");

    if (!disabledLetters.includes(input)) {
      if (charArray.includes(input.toUpperCase())) {
        charArray.forEach((char, index) => {
          if (char === input.toUpperCase()) {
            dashes[index].innerText = char;
            winCount += 1;
            if (winCount === charArray.length) {
              resultText.innerHTML = `<h2 class='win-msg'>You Win!!</h2><p>The word was <span>${chosenWord}</span></p>`;
              blocker();
            }
          }
        });
      } else {
        count += 1;
        drawMan(count);
        if (count === 6) {
          resultText.innerHTML = `<h2 class='lose-msg'>You Lose!!</h2><p>The word was <span>${chosenWord}</span></p>`;
          blocker();
        }
      }

      // Disable the clicked letter button
      letterButtons.forEach((button) => {
        if (button.innerText === input) {
          button.disabled = true;
          disabledLetters.push(input);
        }
      });
    }
  }
};


document.addEventListener("keydown", (event) => {
  if (/^[a-zA-Z]$/.test(event.key)) {
    const input = event.key.toUpperCase();
    handleUserInput(input);
  }
});

const letterButtons = document.querySelectorAll(".letters");
letterButtons.forEach((button) => {
  button.addEventListener("click", () => {
    const input = button.innerText;
    handleUserInput(input);
    button.disabled = true;
  });
});

const generateWord = (optionValue) => {
  let optionsButtons = document.querySelectorAll(".options");

  optionsButtons.forEach((button) => {
    if (button.innerText.toLowerCase() === optionValue) {
      button.classList.add("active");
    }
    button.disabled = true;
  });

  letterContainer.classList.remove("hide");
  userInputSection.innerText = "";

  let optionArray = options[optionValue];

  if (optionArray && optionArray.length > 0) {
    chosenWord = optionArray[Math.floor(Math.random() * optionArray.length)];
    chosenWord = chosenWord.toUpperCase();

    let displayItem = chosenWord.replace(/./g, '<span class="dashes">_</span>');
    userInputSection.innerHTML = displayItem;
  } else {
    userInputSection.innerHTML = "<p>No words available for this difficulty.</p>";
  }
};

// Initial Function (Called when page loads/user presses new game)
const initializer = async () => {
  winCount = 0;
  count = 0;

  // Initially erase all content and hide letters and new game button
  userInputSection.innerHTML = "";
  optionsContainer.innerHTML = "";
  letterContainer.classList.add("hide");
  newGameContainer.classList.add("hide");
  letterContainer.innerHTML = "";

  // For creating letter buttons
  for (let i = 65; i < 91; i++) {
    let button = document.createElement("button");
    button.classList.add("letters");
    // Number to ASCII[A-Z]
    button.innerText = String.fromCharCode(i);
    // Character button click
    button.addEventListener("click", () => {
      const input = button.innerText;
      handleUserInput(input);
      button.disabled = true;
    });
    letterContainer.append(button);
  }

  try {
    //json case sensitive
    options.easy = await fetchOptionsFromJSON("./easy.json");
    options.medium = await fetchOptionsFromJSON("./medium.json");
    options.difficult = await fetchOptionsFromJSON("./difficult.json");
  } catch (error) {
    console.error("Error loading options from JSON files:", error);
  }

  displayOptions();
  // Call to canvasCreator (for clearing the previous canvas and creating the initial canvas)
  let { initialDrawing } = canvasCreator();
  // initialDrawing would draw the frame
  initialDrawing();
};

// Canvas
const canvasCreator = () => {
  let context = canvas.getContext("2d");
  context.beginPath();
  context.strokeStyle = "#000";
  context.lineWidth = 2;

  // For drawing lines
  const drawLine = (fromX, fromY, toX, toY) => {
    context.moveTo(fromX, fromY);
    context.lineTo(toX, toY);
    context.stroke();
  };

  const head = () => {
    context.beginPath();
    context.arc(70, 30, 10, 0, Math.PI * 2, true);
    context.stroke();
  };

  const body = () => {
    drawLine(70, 40, 70, 80);
  };

  const leftArm = () => {
    drawLine(70, 50, 50, 70);
  };

  const rightArm = () => {
    drawLine(70, 50, 90, 70);
  };

  const leftLeg = () => {
    drawLine(70, 80, 50, 110);
  };

  const rightLeg = () => {
    drawLine(70, 80, 90, 110);
  };

  // Initial frame
  const initialDrawing = () => {
    // Clear canvas
    context.clearRect(0, 0, context.canvas.width, context.canvas.height);
    // Bottom line
    drawLine(10, 130, 130, 130);
    // Left line
    drawLine(10, 10, 10, 131);
    // Top line
    drawLine(10, 10, 70, 10);
    // Small top line
    drawLine(70, 10, 70, 20);
  };

  return { initialDrawing, head, body, leftArm, rightArm, leftLeg, rightLeg };
};

// Draw the man
const drawMan = (count) => {
  let { head, body, leftArm, rightArm, leftLeg, rightLeg } = canvasCreator();
  switch (count) {
    case 1:
      head();
      break;
    case 2:
      body();
      break;
    case 3:
      leftArm();
      break;
    case 4:
      rightArm();
      break;
    case 5:
      leftLeg();
      break;
    case 6:
      rightLeg();
      break;
    default:
      break;
  }
};

// New Game
newGameButton.addEventListener("click", initializer);
window.onload = initializer;
