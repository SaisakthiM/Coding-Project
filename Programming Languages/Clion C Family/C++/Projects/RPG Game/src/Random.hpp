#include <random>

struct Random {
    double random_double() {
        static std::random_device rd;
        static std::mt19937 gen(rd());

        std::uniform_real_distribution<> dist(0.0, 1.0);

        return dist(gen);
    }
};