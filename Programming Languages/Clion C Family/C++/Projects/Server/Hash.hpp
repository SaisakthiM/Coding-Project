#include <string>

struct Hash {
    int findHash(std::string &s) {
        int n = s.length();
        // p is a prime number
        // m is a large prime number
        int p = 31, m = 1e9 + 7;

        // to store hash value
        int hashVal = 0;

        // to store p^i
        int pPow = 1;

        // Calculating hash value
        for (int i = 0; i < n; ++i) {
            hashVal = (hashVal + (s[i] - 'a' + 1) * pPow) % m;
            pPow = (pPow * p) % m;
        }
        return hashVal;
    };
};