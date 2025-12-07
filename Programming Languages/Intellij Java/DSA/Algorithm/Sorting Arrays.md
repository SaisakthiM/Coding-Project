# 📘 Sorting Algorithms in Arrays (Java-Focused)

Sorting algorithms are essential for organizing data efficiently.  
Different algorithms optimize for **speed**, **memory**, and **stability** depending on the use case.

---

## 🔹 1. Bubble Sort

### **Concept**  
Bubble Sort compares adjacent elements and swaps them if they are in the wrong order.  
Each pass “bubbles” the largest value to the end.

### **Characteristics**
- **Best Case:** O(n)  
- **Average Case:** O(n²)  
- **Worst Case:** O(n²)  
- **Space Complexity:** O(1)  
- **Stable:** Yes  

### **Java Example**
```java
public void bubbleSort(int[] arr) {
    int n = arr.length;
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}
```

---

## 🔹 2. Selection Sort

### **Concept**  
Selection Sort finds the minimum element from the unsorted portion and places it at the beginning.

### **Characteristics**
- **Best Case:** O(n²)  
- **Average Case:** O(n²)  
- **Worst Case:** O(n²)  
- **Space Complexity:** O(1)  
- **Stable:** No  

### **Java Example**
```java
public void selectionSort(int[] arr) {
    int n = arr.length;

    for (int i = 0; i < n - 1; i++) {
        int minIndex = i;

        for (int j = i + 1; j < n; j++) {
            if (arr[j] < arr[minIndex]) {
                minIndex = j;
            }
        }

        int temp = arr[minIndex];
        arr[minIndex] = arr[i];
        arr[i] = temp;
    }
}
```

---

## 🔹 3. Insertion Sort

### **Concept**  
Insertion Sort takes one element at a time and inserts it into its correct position among previously sorted elements.

### **Characteristics**
- **Best Case:** O(n)  
- **Average Case:** O(n²)  
- **Worst Case:** O(n²)  
- **Space Complexity:** O(1)  
- **Stable:** Yes  

### **Java Example**
```java
public void insertionSort(int[] arr) {
    int n = arr.length;

    for (int i = 1; i < n; i++) {
        int key = arr[i];
        int j = i - 1;

        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            j--;
        }

        arr[j + 1] = key;
    }
}
```

---

## 🔹 4. Merge Sort

### **Concept**  
Merge Sort is a **divide-and-conquer** algorithm that splits the array into halves, sorts each half, and merges the results.

### **Characteristics**
- **Best Case:** O(n log n)  
- **Average Case:** O(n log n)  
- **Worst Case:** O(n log n)  
- **Space Complexity:** O(n)  
- **Stable:** Yes  

### **Java Example**
```java
public void mergeSort(int[] arr, int left, int right) {
    if (left < right) {
        int mid = (left + right) / 2;

        mergeSort(arr, left, mid);
        mergeSort(arr, mid + 1, right);

        merge(arr, left, mid, right);
    }
}

private void merge(int[] arr, int left, int mid, int right) {
    int n1 = mid - left + 1;
    int n2 = right - mid;

    int[] L = new int[n1];
    int[] R = new int[n2];

    for (int i = 0; i < n1; i++) L[i] = arr[left + i];
    for (int i = 0; i < n2; i++) R[i] = arr[mid + 1 + i];

    int i = 0, j = 0, k = left;

    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) arr[k++] = L[i++];
        else arr[k++] = R[j++];
    }

    while (i < n1) arr[k++] = L[i++];
    while (j < n2) arr[k++] = R[j++];
}
```

---

## 🔹 5. Quick Sort

### **Concept**  
Quick Sort partitions the array around a **pivot**.  
Elements smaller than the pivot go left; larger ones go right.

### **Characteristics**
- **Best Case:** O(n log n)  
- **Average Case:** O(n log n)  
- **Worst Case:** O(n²)  
- **Space Complexity:** O(log n)  
- **Stable:** No  

### **Java Example**
```java
public void quickSort(int[] arr, int low, int high) {
    if (low < high) {
        int pivotIndex = partition(arr, low, high);

        quickSort(arr, low, pivotIndex - 1);
        quickSort(arr, pivotIndex + 1, high);
    }
}

private int partition(int[] arr, int low, int high) {
    int pivot = arr[high];
    int i = low - 1;

    for (int j = low; j < high; j++) {
        if (arr[j] <= pivot) {
            i++;
            int temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
        }
    }

    int temp = arr[i + 1];
    arr[i + 1] = arr[high];
    arr[high] = temp;

    return i + 1;
}
```

---

## 🔹 6. Heap Sort

### **Concept**  
Heap Sort uses a **binary heap structure** to repeatedly extract the maximum element until the array is sorted.

### **Characteristics**
- **Best Case:** O(n log n)  
- **Average Case:** O(n log n)  
- **Worst Case:** O(n log n)  
- **Space Complexity:** O(1)  
- **Stable:** No  

### **Java Example**
```java
public void heapSort(int[] arr) {
    int n = arr.length;

    for (int i = n / 2 - 1; i >= 0; i--) {
        heapify(arr, n, i);
    }

    for (int i = n - 1; i >= 0; i--) {
        int temp = arr[0];
        arr[0] = arr[i];
        arr[i] = temp;

        heapify(arr, i, 0);
    }
}

private void heapify(int[] arr, int n, int i) {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    if (left < n && arr[left] > arr[largest]) largest = left;
    if (right < n && arr[right] > arr[largest]) largest = right;

    if (largest != i) {
        int temp = arr[i];
        arr[i] = arr[largest];
        arr[largest] = temp;

        heapify(arr, n, largest);
    }
}
```

---

## ✔ Summary Table

| Algorithm      | Best | Avg | Worst | Space | Stable |
|----------------|------|------|--------|--------|---------|
| Bubble Sort    | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Selection Sort | O(n²) | O(n²) | O(n²) | O(1) | No |
| Insertion Sort | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Merge Sort     | O(n log n) | O(n log n) | O(n log n) | O(n) | Yes |
| Quick Sort     | O(n log n) | O(n log n) | O(n²) | O(log n) | No |
| Heap Sort      | O(n log n) | O(n log n) | O(n log n) | O(1) | No |
