"""

API 

A word which every programmer in the world heard once in their life.
This is the power of API

To completely understand it we start explaining the individual letters
Starting from I - The Interface


Interface, Not a big deal. It's simple.
Everyone knows a Alarm Clock right.
What you can do in it
Change Minute, Seconds and Hours
Change Ringtone
Change the Alarm Time

Do you know how it works
The most probable answer is no
But you know I can change time and alarm
That is a Interface
A Interface allows a user to modify things easily without understanding deeply about how it works
GUI - Graphical User Interface

If it is hardware, it's just Interface
If it is software, say spotify
I don't know how spotify works but i know that if i hit play button for a music, it plays music
It is GUI

Important: To simplely put, Interface is a hardware or software environment
where users are allowed to change or modify things 
without the need of the user to actually understand how it works behind

-------------------------------------------------------------------------------------------------------------------------------------

So What is a API:
API is a Interface where programmers are allowed to extract/modify data allowed in that interface.
This helps reduce coding a feature from scratch
a programmer can just use a feature which is available via API and connect it to his hardware/software 
to save time and bugs

---------------------------------------------------------------------------------------------------------------------------------

Web-Based API :
Before Learning that, we have to learn about how an web browser works.

https://www.google.com

A user wants to connect to a server of Google. for that we use what's called URL or
Uniform Resource Locator. all websites have one to identify from other
Sometimes, we also use URI or Uniform Resource Identifier

now we come to the HTTPS part. it's full form is Hyper Text Transfer Protocol Secure
HTTP is a Protocol, We have to know about protocol first. 
A protocol is a set of steps to have a efficient communication between 2 Devices.

Say P when I say HTT. 
If you say P, Congrats we formed a protocol.
I gave you a task, in internet basis a Request
You responded to task Yes, in internet basis it is a SYN-ACK package
Then I told HTT, in internet basis it is Response

Generally if we use Google, It sends a HTTP request
In that HTTP request, it has URL and a Method
Generally, we use GET method which gets the Response and send it back.

-----------------------------------------------------------------------------------------------------------------------------

REST API :
Representational State Transfer API

So what are constrains that can define a API is REST state
there are 7 constrains

Client-Server Architecture
Statelessness
Cacheability
Layered System
Code on Demand
Uniform Interface

These are the 7 constrains needed to be followed for a API to be considered RESTful

1) Client-Server Architecture : Let's say now you are using google. It has a Server and you are a Client.
                                That's it you got past 1st stage
2) Statelessness : You need to search about dogs in google. 
                   you search and you (client) end a HTTP request which is mostly stateless.

                   [The difference between stateless and state is that 
                   stateless request remembers or saves your request for further use
                   While stateless dispose your request as soon as client gets the response]
                   Example of Stateless are UDP , DNS , HTTP , etc. 
                   Example of Stateful are FTP , Telnet , etc.

Now let's talk about Request
So what is a request. we hear like HTTP request or FTP request
but what it is requesting
It is most probably a Resource, The R in URL or URI
Resource is a Abstract word, what exactly is a Resource

Simple, A Resource is a data that can be CRUDed
What is that word CRUD, It is Create Read Update Delete
A Data that can be Created Read Updated and Deleted is known as Resource

------------------------------------------------------------------------------------------------------------------------------

What's the Structure of API : 

Ok first we can see how a REST API request looks like

GET /users HTTP/1.1
Host: api.example.com
Authorization: Bearer YOUR_TOKEN

here, 
GET is the HTTP method used by an API to retrieve data from the server.
this below is a table we can use diffrerent types of methods 

| Method      | Purpose / Use Case                                   | Body Allowed? |
| ----------- | ---------------------------------------------------- | ------------- |
| **GET**     | Retrieve data from the server                        | No            |
| **POST**    | Create new data on the server                        | Yes           |
| **PUT**     | Update existing data completely                      | Yes           |
| **PATCH**   | Update existing data partially                       | Yes           |
| **DELETE**  | Delete data from the server                          | Rarely        |
| **OPTIONS** | Check which HTTP methods are supported by the server | No            |
| **HEAD**    | Retrieve headers only (no response body)             | No            |

that HTTP/1.1 is the protocol used for establishing the network 

| Protocol      | Layer           | Purpose / Use Case                                | Typical Port |
| ------------- | --------------- | ------------------------------------------------- | ------------ |
| **HTTP**      | Application     | Web pages, REST APIs                              | 80           |
| **HTTPS**     | Application     | Secure web pages, REST APIs                       | 443          |
| **FTP**       | Application     | File transfer                                     | 21           |
| **SFTP**      | Application     | Secure file transfer over SSH                     | 22           |
| **WebSocket** | Application     | Real-time communication (chat, live updates)      | 80/443       |
| **SMTP**      | Application     | Sending emails                                    | 25           |
| **IMAP**      | Application     | Reading emails                                    | 143          |
| **POP3**      | Application     | Reading emails                                    | 110          |
| **TCP**       | Transport       | Reliable communication, base for HTTP/FTP/SMTP    | N/A          |
| **UDP**       | Transport       | Fast, unreliable communication (streaming, games) | N/A          |
| **DNS**       | Application/UDP | Domain name resolution                            | 53           |















































"""