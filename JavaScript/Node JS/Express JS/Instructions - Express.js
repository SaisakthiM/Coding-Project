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

now we know basic routing we can move on to next level of routing 

as you can see in the syntax itself, we know the method 
Note: there is also a function called app.all() which i used to load all middleware for all requests

now there is also may types of routing 

1) Path/Static Routing : this is the mostcommon type of routing 
so here we mention the routes via 
Syntax : /path 

the/ is the root point and after that you can have a specific end-point and you can also stack it like 
/api/users/end
like this

2) Pattern Routing : 

| Pattern | Meaning                          | Example                                          |
| ------- | -------------------------------- | ------------------------------------------------ |
| `?`     | Optional character               | `/ab?cd` matches `/acd` or `/abcd`               |
| `+`     | One or more of previous char     | `/ab+cd` matches `/abcd`, `/abbcd`, `/abbbcd`    |
| `*`     | Wildcard — any string in between | `/ab*cd` matches `/abcd`, `/ab123cd`, `/abXYZcd` |
| `()`    | Grouping for optional sections   | `/a(bc)?d` matches `/ad` or `/abcd`              |

this is a very good routing if you want to have multiple repetitive routing routes

and here is a question

app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "index.html"));
});

app.get('/ab?cd', (req, res) => {
  res.send('Matched pattern route!');
});

app.get('/ab+cd', (req,res) => {
    res.send("Hi")
})
app.get('/ab*cd', (req,res) => {
    res.send("Hi hello")
})

which will render first 
hi or hi hello 
it's hi because of request handling 
if it found a match 





















*/