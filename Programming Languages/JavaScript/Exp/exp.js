let arr = [1,2,3,4,5,6,7,8,2,5];

function findDuplicate(arr) {
    let hash = {};
    let result = [];

    for (let i = 0; i < arr.length; i++) {
        if (hash[arr[i]]) {
            hash[arr[i]] += 1;
        } else {
            hash[arr[i]] = 1;
        }
    }

    // Collect only duplicates
    for (let key in hash) {
        if (hash[key] > 1) {
            result.push(Number(key));
        }
    }

    console.log("Duplicates:", result);
}
findDuplicate(arr);
