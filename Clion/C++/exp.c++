#include <iostream>
#include <thread>
#include <chrono>

int main() {
    std::cout << "Memory leak demo started.\n";

    while (true) {
        // Allocate 10 MB repeatedly without freeing
        int* leak = new int[250000000];  // ~10 MB (4 bytes per int)
        for (int i = 0; i < 2500000; ++i)
            leak[i] = i;
        
        std::cout << "Allocated 10 MB, total leak increasing...\n";

        // Sleep a bit so you can watch memory usage in Task Manager
        std::this_thread::sleep_for(std::chrono::seconds(1));
    }

    return 0;
}
