class Exercise {
    constructor(arr) {
        this.arr = arr;
    }
    isarray() {
        return Array.isArray(this.arr);
    }

    first(n = 1) {
        let res = [];
        for (let i = 0; i < n; i++) {
            res.push(this.arr[i]);
        }
        return res;
    }
    sort() {
        this.arr.sort();
        return this.arr;
    }

    frequent_element() {
        // Initialize variables to track the most frequent item, its frequency, and the current item's frequency
        let mf = 1;
        let m = 0;
        let item;

        // Iterate through the array to find the most frequent item
        for (let i = 0; i < this.arr.length; i++) {
            // Nested loop to compare the current item with others in the array
            for (let j = i; j < this.arr.length; j++) {
                // Check if the current item matches with another item in the array
                if (this.arr[i] == this.arr[j])
                    m++;
                // Update the most frequent item and its frequency if the current item's frequency is higher
                if (mf < m) {
                    mf = m;
                    item = this.arr[i];
                }
            }
            // Reset the current item's frequency for the next iteration
            m = 0;
        }
        return item;
    }
    swap_case() {
        
    }
}

let k = new Exercise([1, 23]);
console.log(k.isarray());  // true
console.log(new Exercise([7, 9, 0, -2]).first(3)); // [7, 9, 0]
console.log(new Exercise([ -3, 8, 7, 6, 5, -4, 3, 2, 1 ]).sort()); // [-4, -3, 1, 2, 3, 5, 6, 7, 8]
