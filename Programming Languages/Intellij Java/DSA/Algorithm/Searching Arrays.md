# 📘 Searching Algorithms in Arrays
Arrays allow direct indexing, which enables many efficient searching techniques.  
This chapter covers all major searching algorithms used in Java and other languages.

---

# 🔍 1. Linear Search

### ✔ Idea
Scan each element one by one until the match is found.

### ✔ When to Use
- Unsorted arrays
- Small datasets

### ✔ Time Complexity
- Best: O(1)
- Worst: O(n)

---

# 🔍 2. Binary Search

### ✔ Requirement
Array must be **sorted**.

### ✔ Idea
Divide the array into halves repeatedly by comparing with the middle.

### ✔ Time Complexity
- O(log n)

### ✔ Notes
- One of the most important algorithms
- Cannot be used for linked lists efficiently

---

# 🔍 3. Jump Search

### ✔ Idea
Jump ahead by √n steps, then backward linear search inside the block.

### ✔ Time Complexity
- O(√n)

### ✔ Best Use Case
Searching sorted arrays when binary search is not preferred.

---

# 🔍 4. Interpolation Search

### ✔ Idea
Binary search assumes values are evenly spaced.  
Interpolation search improves it by estimating the position based on value.

### ✔ Time Complexity
- Average: O(log log n)
- Worst: O(n)

### ✔ Best Use Case
Uniformly distributed sorted arrays.

---

# 🔍 5. Exponential Search

### ✔ Idea
Expand range exponentially (1, 2, 4, 8...) until the element is found or passed.  
Then apply binary search in that range.

### ✔ Time Complexity
- O(log n)

### ✔ Use Case
Unbounded or very large arrays.

---

# 🔍 6. Searching in 2D Matrices

---

## 6.1 Nested Search (Unsorted Matrix)
- Brute-force row/column scanning  
- Time: O(n × m)

---

## 6.2 Row/Column Binary Search
- Works when rows are sorted
- Time: O(n log m)

---

## 6.3 Staircase Search (Rows & Columns Sorted)
- Start from top-right, move left/down
- Time: O(n + m)

---

## 6.4 Flattened Binary Search (Fully Sorted Matrix)
- Treat matrix as 1D array
- Time: O(log(n × m))

---

# 🔍 7. Searching in 3D Matrices

---

## 7.1 Triple Nested Loop
- Time: O(x × y × z)

---

## 7.2 Layer-wise Binary Search
- Apply 2D search to each layer

---

## 7.3 Fully Flattened Search
- 3D array → 1D mapping
- Time: O(log(x × y × z))

---

# 🔍 8. Pivot Search (Rotated Sorted Array)

---

## 8.1 What Is a Rotated Sorted Array?
Example:
[4, 5, 6, 7, 1, 2, 3]

---

## 8.2 Method: Modified Binary Search
At every step, one half is sorted.

### ✔ Time Complexity
- O(log n)

---

## 8.3 Variant: Pivot + Binary Search
1. Find pivot (minimum element)
2. Run binary search in correct half

---

## 8.4 With Duplicates
Worst case becomes **O(n)**.

---

# 📘 Summary Table

| Algorithm | Sorted? | Time | Best Use Case |
|----------|---------|-------|---------------|
| Linear Search | No | O(n) | Small/unsorted arrays |
| Binary Search | Yes | O(log n) | Most efficient search |
| Jump Search | Yes | O(√n) | Middle-ground technique |
| Interpolation Search | Yes + uniform | O(log log n) | Phonebooks, uniform data |
| Exponential Search | Yes | O(log n) | Unbounded arrays |
| Staircase Search | 2D sorted | O(n + m) | Matrix search |
| Pivot Search | Rotated sorted | O(log n) | Rotated arrays |

---

# 🎯 End of Array Searching Algorithms

Next chapter will include:  
- Sorting Algorithms  
- Two Pointers  
- Sliding Window  
- Trees / Graph Search  
- Graph Traversal (BFS/DFS)
