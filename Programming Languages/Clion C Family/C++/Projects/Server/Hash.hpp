#include <string>

struct Hash {
    long long findHash(std::string &s) {
        long long n = s.length();
        // p is a prime number
        // m is a large prime number
        long long p = 31, m = 1e9 + 7;

        // to store hash value
        long long hashVal = 0;

        // to store p^i
        long long pPow = 1;

        // Calculating hash value
        for (long long i = 0; i < n; ++i) {
            hashVal = (hashVal + (s[i] - 'a' + 1) * pPow) % m;
            pPow = (pPow * p) % m;
        }
        return hashVal;
    };
};