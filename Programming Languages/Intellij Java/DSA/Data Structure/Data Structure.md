# 📘 Introduction to Data Structures (Java Focused)
Understanding Data Structures is the foundation of mastering DSA.  
Every program processes **data**, and the efficiency of handling that data depends on  
how it is **stored**, **accessed**, and **manipulated**.

Before going into algorithms, it is important to understand *how data flows* and  
*how memory works*, because algorithms are simply optimized ways of accessing data.

---

# 🔍 1) Memory Address and Pointers

Even in Java (which hides pointers), the concept of memory addressing matters.

### ✔ What is a Memory Address?
A memory address represents the exact location where data is stored in RAM.  
Every variable, array element, and object has an address.

### ✔ Why Pointers Still Matter in Java?
Java does not allow pointer arithmetic, but:
- Every object reference is **internally a pointer**.
- The JVM uses pointers to manage:
  - Stack frames
  - Object references
  - Heap allocation

### ✔ How Java Manages Memory
- **Primitive types** → stored directly on the stack
- **Objects & arrays** → stored on the heap, referenced by addresses
- The JVM performs **automatic memory management** (Garbage Collection)

Understanding this helps in analyzing:
- Time complexity
- Reference copying vs deep copying
- Linked list node connections
- Tree and Graph structures

---

# 📦 2) Arrays and Linked Lists

These are the foundational linear data structures.

---

## 2.1 Arrays

### ✔ Characteristics
- Contiguous memory
- Fixed size
- Indexed access (`O(1)` for arr[i])

### ✔ When to Use
- Quick indexed access
- Small or fixed-size datasets
- Binary search (requires sorted array)

### ✔ Limitations
- Expensive insertion/deletion
- Fixed memory allocation

---

## 2.2 Linked Lists

### ✔ Characteristics
- Nodes connected using pointers/references
- Dynamic size
- Sequential access

### ✔ Types
- Singly Linked List
- Doubly Linked List
- Circular Linked List

### ✔ When to Use
- Frequent insertions/deletions
- Dynamic/unknown size data

### ✔ Limitations
- No random access
- Extra memory for pointers

---

# 🧠 3) Hash Maps and Hash Tables

Hash-based structures allow **near O(1) lookup** using hash functions.

---

## 3.1 How Hashing Works

A **hash function** converts a key → index.  
Example:

### ✔ Hash Map (Java)
- Uses array + linked lists / trees
- Handles collisions using:
  - Separate chaining (LinkedList)
  - Tree bins (after Java 8)

### ✔ Benefits
- Fast lookups
- Efficient for large datasets

### ✔ Limitations
- Requires good hashing
- Order is not guaranteed

---

# 🧱 4) Stack, Heap and Queue

These structures manage data flow in programs.

---

## 4.1 Stack
Follows **LIFO (Last In First Out)**  
Used for:
- Function calls
- Undo operations
- Expression evaluation

Java uses a call stack for:
- Local variables
- Method call frames

---

## 4.2 Heap
Used for:
- Objects
- Arrays
- Dynamic allocations

Garbage Collector manages unused heap objects.

---

## 4.3 Queue
Follows **FIFO (First In First Out)**  
Used for:
- Scheduling
- Thread management
- BFS (Breadth-first search)

Types of Queues:
- Simple Queue
- Deque
- PriorityQueue

---

# 🌳 5) Trees and Graphs

These represent hierarchical and networked data.

---

## 5.1 Trees
A tree is a hierarchical structure with:
- Nodes
- Parent-child relationships

### Common Types:
- Binary Tree
- Binary Search Tree (BST)
- AVL Tree
- Heap
- Trie

### Usage:
- Searching
- Routing tables
- Indexing (Databases, Filesystems)

---

## 5.2 Graphs
Graphs represent networks using **nodes** and **edges**.

Types:
- Directed / Undirected
- Weighted / Unweighted

Usage:
- Social networks
- Maps (Dijkstra, BFS, DFS)
- Compilers
- Operating Systems

---

# 🎯 Summary

Java supports all standard data structures:
- Arrays
- Linked Lists
- HashMaps
- Stacks & Queues
- Trees & Graphs

While the implementation differs from C/C++,  
the underlying concepts (memory, pointers, references) remain universal.

This understanding forms the base for studying algorithms next.
