const express = require("express");
const cors = require("cors");
const app = express();
const bodyParser = require("body-parser");
const { MongoClient } = require("mongodb");

app.use(cors());
app.use(bodyParser.json());
app.use(cors({
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
}));


const port = 8081;
const host = "localhost";

const url = "mongodb://127.0.0.1:27017";
const dbName = "team15_final";
const client = new MongoClient(url);
const db = client.db(dbName);

app.listen(port, () => {
  console.log("App listening at http://%s:%s", host, port);
});

app.get("/", (req, res) => {
  res.send("Hello, World!");
});

// READ
app.get("/listWords", async (req, res) => {
  await client.connect();
  console.log("Node connected successfully to GET MongoDB");

  const query = {};
  const results = await db
    .collection("words")
    .find(query)
    .limit(100)
    .toArray();

  console.log(results);
  res.status(200).send(results);
});

// CREATE
app.post("/listWords", async (req, res) => {
  try {
    const { word } = req.body;

    if (!word) {
      return res
        .status(400)
        .send("Bad Request: Missing required field 'word'.");
    }

    const newDocument = {
      word: word,
    };

    const result = await db.collection("words").insertOne(newDocument);

    // Fetch the newly added document including _id
    const addedWord = await db
      .collection("words")
      .findOne({ _id: result.insertedId });

    res.status(201).json(addedWord);
  } catch (error) {
    console.error('Error adding word:', error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

// READ
app.get("/listWords/:word", async (req, res) => {
  const wordName = req.params.word;

  await client.connect();
  console.log("Node connected successfully to GET-word MongoDB");
  const query = { word: wordName };
  const results = await db.collection("words").findOne(query);
  console.log("Results:", results);

  if (!results) res.status(404).send("Not Found");
  else res.status(200).send(results);
});

// UPDATE
app.put("/listWords/:word", async (req, res) => {
  const wordName = req.params.word;

  try {
    const { newWord } = req.body;

    if (!newWord) {
      return res
        .status(400)
        .send("Bad Request: Missing required field 'newWord'.");
    }

    await client.connect();

    const query = { word: wordName };
    const update = { $set: { word: newWord } };
    const result = await db.collection("words").updateOne(query, update);

    if (result.modifiedCount > 0) {
      res.sendStatus(204); // Updated successfully
    } else {
      res.status(404).send("Word not found");
    }
  } catch (e) {
    res.sendStatus(500); // Internal Server Error
  }
});


// DELETE
app.delete("/listWords/:word", async (req, res) => {
  const wordName = req.params.word;

  try {
    await client.connect();

    const query = { word: wordName };
    const result = await db.collection("words").deleteOne(query);

    if (result.deletedCount > 0) {
      res.sendStatus(204);
    } else {
      res.status(404).send("Word not found");
    }
  } catch (e) {
    res.sendStatus(500);
  }
});

