/*

First we have to learn what is node and how it runs

we know that JS runs in browser engines like V8 for chrome.
but it cannot run natively which makes sense as JS is a "Scripting language"
so now some decided to change that
we cannot just create a compiler because it is a "Scripting Language"
so what node does is it recreated the V8 engine and compiled it is a interpreter
which allowed JS to run locally

more importantly it allowed developers to run locally, testing and most-importantly 
now we can develop backend servers with node js and also create modules with NPM
node package manager

and now we have to know a bit basics of what is a process and a thread 
we can learn that with a simple analogy 

The Orchestra Analogy for Processes and Threads

The Process = the Orchestra itself
It’s the entire musical setup — the stage, sheet music, conductor, and all musicians.
It owns the resources (instruments, space, and music notes = memory, files, and variables).
Everything that happens musically is contained within this orchestra.
It operates independently from other orchestras (other processes).

The Threads = the Musicians
Each musician (thread) performs a specific part of the composition.
They all share the same sheet music and space (shared memory), but each one plays their own instrument (execution path).
They can work in parallel — but if one plays the wrong note loudly enough (crashes), the whole performance (process) can be ruined.

now we can talk about event loop

The event loop is Node.js’s mechanism that allows it to handle multiple tasks at the same time without creating multiple threads.
It constantly checks for tasks that are ready to run — running synchronous code first, then microtasks (Promises), and finally macrotasks (timers, I/O callbacks).
This is how Node.js achieves non-blocking, asynchronous execution on a single main thread.




*/