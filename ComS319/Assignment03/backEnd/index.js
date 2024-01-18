var express = require("express");
var cors = require("cors");
var app = express();
var fs = require("fs");
var bodyParser = require("body-parser");
const { MongoClient, AggregationCursor } = require("mongodb");


app.use(cors());
app.use(bodyParser.json());
app.use(express.static("images"));

const port = "8081";
const host = "localhost";

// Mongo
const url = "mongodb://127.0.0.1:27017";
const dbName = "reactdata";
const client = new MongoClient(url);
const db = client.db(dbName);

app.listen(port, () => {
  console.log("App listening at http://%s:%s", host, port);
});

app.get("/", (req, res) => {
  res.send("Hello, World!");
});

// READ ALL
app.get("/products/", async (req, res) => {
  await client.connect();
  console.log("Node connected successfully to GET MongoDB");

  const query = {};
  const results = await db
    .collection("fakestore_catalog")
    .find(query)
    .limit(100)
    .toArray();

  results.forEach(r => {
    // convert relative URLs
    // if (r.image.length > 0 && r.image[0] == '/') {
    if (r.image && r.image.length > 0 && r.image[0] === '/') {
      console.error("what?");
      r.image = `http://${host}:${port}${r.image}`
    }
  })
    
  console.log(results);
  res.status(200);
  res.send(results);
});

// READ
app.get("/products/:id", async (req, res) => {
  const _id = req.params.id;
  console.log("Product id to find :", _id);

  await client.connect();
  console.log("Node connected successfully to GET-id MongoDB");
  const query = { _id };
  const results = await db.collection("fakestore_catalog").findOne(query);
  console.log("Results :", results);

  if (!results) res.send("Not Found").status(404);
  else res.send(results).status(200);
});

// CREATE
app.post("/products/", async (req, res) => {
  console.log("REACHED,", req.body);
  
  
  if (isNaN(req.body._id)) {
    res.sendStatus(400);
    return;
  }

  try {
    price = Number(req.body.price);
    rate = Number(req.body.rating.rate);
    count = Number(req.body.rating.count);

    const newDocument = {
      price,
      rating: {rate, count},
      ...req.body};

    await client.connect();
    newDocument.price = Number(price);
    newDocument.rating.rate = Number(newDocument.rating.rate);
    newDocument.rating.count = Number(newDocument.rating.count);
    db.collection("fakestore_catalog").insertOne
    const results = await db.collection("fakestore_catalog").insertOne(newDocument);
    res.status(200)
    res.send(results)
  } catch (e) {
    console.error("Failed to create new product:", e);
    res.sendStatus(500);
    return;
  }
});

// DELETE
app.delete("/products/:id", async (req, res) => {
  if (isNaN(req.params.id)) {
    res.sendStatus(400);
    return;
  }

  try {
    await client.connect();

    console.log(`Attempting to delete ${req.params.id}`);

    const query = { _id: req.params.id };
    const results = await db.collection("fakestore_catalog").deleteOne(query);
    console.log(results)
    if (results.deletedCount > 0) {
      res.sendStatus(204);
      return;
    } else {
      res.sendStatus(404);
      return;
    }
  } catch (e) {
    res.sendStatus(500);
    return;
  }
});

// UPDATE
app.put("/products/:id", async (req, res) => {
  const {price} = req.body;
  try {
    if (!price || isNaN(price) || price < 0) {
      res.status(400).send("Invalid field: price");
      return;
    }

    await client.connect();
    console.log("Node connected successfully to updatePrice MongoDB");

    const query = { _id: req.params.id };
    const results = await db.collection("fakestore_catalog").findOneAndUpdate(query, {$set: { "price" : price}})
    console.log("Updated product:", results);
    res.status(200).send(results);
  } catch (e) {
    console.error(e)
    res.sendStatus(500)
  }
});
