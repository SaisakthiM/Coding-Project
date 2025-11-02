/*

What is Express.js?

Express.js is a minimal and flexible web framework for Node.js used to build web applications and APIs.

It simplifies how you handle:
HTTP requests (GET, POST, PUT, DELETE)
Routing (URLs and endpoints)
Middleware (functions that process requests)
Error handling
Static files (HTML, CSS, JS)

In simple terms:

Node.js = Engine
Express.js = Framework that gives structure to your Node app

Why Use Express Instead of Plain Node.js?

| Feature      | Plain Node.js                    | Express.js                                        |
| ------------ | -------------------------------- | ------------------------------------------------- |
| Routing      | Manual setup using `http` module | Built-in `app.get()`, `app.post()`, etc.          |
| Middleware   | Must handle everything yourself  | Has a full middleware system                      |
| JSON Parsing | Requires manual parsing          | Automatically done                                |
| Scalability  | Hard to manage routes            | Supports modular route files                      |
| Community    | Smaller                          | Massive ecosystem (npm packages, templates, etc.) |

CRUD Operations :

the CRUD operations are the most important operations for a server to do
after all it is made for this purpose 

so we have a doubt how can we do this in express js 
it's simple than you think 

just import the module and use it like

for GET (Read) request : app.get()
for POST (Create) request : app.post()
for PUT (Update) request: app.put()
for DELETE (Delete) request : app.delete()

Eg : 

import express from "express";
let app = express();
app.get("/", (req, res) => {
    res.send("Hello World");
})
app.listen(8000, () => {
    console.log("hi")
})

Routing : 
It is a very important thing in backend as it determines which path the request are sent and some paths works, 
some paths doesn't and some path are specialized

Definitions : 
Routing refers to determining how an application responds to a client request to a particular endpoint, 
which is a URI (or path) and a specific HTTP request method (GET, POST, and so on).

app.METHOD(PATH, HANDLER)

this is the syntax

Code :
app.get('/', (req, res) => {
  res.send('Hello World!')
})

here app is the express module (we decalred it in top)

and / is the path which is root path


















*/