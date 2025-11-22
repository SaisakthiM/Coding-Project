/*

First before going deep into how database is created we have to know what's a Database

Database : It is nothing but collection of information 

that's all we need to know 
so not only database is a collection of information 
there are more

so what's the use of the information if we are not using it 
how are we creating and deleting these information 
and how are we updating the information overtime

That's CRUD : Create Read Update Delete 
operation. like maths aritmetic operations we can't do anything useful without thes CRUD operations

so now how are we going to use these CRUD operations on information 
we have + for addition and - for subtract and so on 

we have Queries in databases to do the same CRUD operations 
so Query is a line of syntax supported by that database to do these CRUD operations and 
there are more than CRUD in database like search too 


so now we have figured out how information is taken or readed out
so the main point is how are we storing it
is the information connected to other information 
or not

there comes realtional and non-relational databases 
which are the 2 main classification in database

there is also where you are storting 
is that data temporary (ephemeral) or permanant (persistent)
that one thing 

and before we are going to see these databases and queries we have to know how the data is structured here
and even before that we are going to see how databses works behind the scenes

here take we are the client and the database is elsewhere like in other country

I) The Networking Layer : 
The networking layer is important because we need to communicate with the client to give them what they want 

II) Query Processing / Front-End: 

The Instruction is sent now we have to process this query for further validation and 
do what client intended to do

1) Tokenizer : 
The Client (that's me) sending the insructions in query 
how a database is going to parse that, a computer can't read words or sentences
so we first tokenize all these to breakd-down what instruction client sent and is that valid

2) Parser : 
The Query is valid and all is set. so now we have to parse the tokens to do the operation 
client intended us to do. so the parser sends a parser tree on what to be executed and how it should be 

3) Optimizer : 
Yes, the parser sent us how to execute but is it efficient and faster
most of the time no
so for these cases we have optimizer which optimizes the instructions to fetch the data faster
and this is the part where the tree also gets sent as a bytecode instruction to be understood by the executor

III) Execution Engine : 
We got the data now we have to execute the data now. how are we going to do that

1) Query Executor : 
Name itself tells it's puropese bruh

2) Cache Management : 
This stores all the frequently accessed data's and information and use it directly instead of repetitive fetching

3) Utility Services : 
These are services created by that database for services like authentication and so on

IV) ACID Manager :

So for the relational databases we have to maintain all the ACID properties

| ACID Property   | Definition                                                                                                           |
| --------------- | -------------------------------------------------------------------------------------------------------------------- |
| **Atomicity**   | Ensures a transaction is **all-or-nothing**; either all operations succeed or none do.                               |
| **Consistency** | Ensures a transaction takes the database from **one valid state to another**, maintaining all rules and constraints. |
| **Isolation**   | Ensures **transactions do not interfere** with each other, preventing inconsistent data.                             |
| **Durability**  | Ensures that once a transaction is **committed**, its changes are **permanent**, even if the system crashes.         |

here is the definitions of each of the property 


























so first we can see the peristent relational database which is the most common database used today 
















 */