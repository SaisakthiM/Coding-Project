#include <climits>
#include <cmath>
#include <iostream>
#include <vector>
#include <string>
#include <algorithm>

class Process {
public:
    int pid;
    int cpuBurst;
    int priority;       // higher number = higher priority
    std::string state;  // "ready", "running", "finished"
};

// Function to display the process table
void displayTable(const std::vector<Process>& processes) {
    std::cout << "PID\tState\tCPU Burst\tPriority\n";
    for (const auto& p : processes) {
        std::cout << p.pid << "\t" << p.state << "\t" << p.cpuBurst << "\t\t" << p.priority << "\n";
    }
    std::cout << "----------------------------------------\n";
}

// Compute mean difference of CPU bursts for ready processes
double meanDifferenceAllPairs(const std::vector<Process>& processes) {
    std::vector<int> bursts;
    for (auto &p : processes) {
        if (p.state == "ready") bursts.push_back(p.cpuBurst);
    }

    if (bursts.size() < 2) return 0;

    double sum = 0;
    int count = 0;
    for (size_t i = 0; i < bursts.size(); i++) {
        for (size_t j = i+1; j < bursts.size(); j++) {
            sum += std::abs(bursts[i] - bursts[j]);
            count++;
        }
    }
    return sum / count;
}

int main() {
    // Step 1: Create processes
    std::vector<Process> processTable = {
        {1, 4, 2, "ready"},
        {2, 3, 1, "ready"},
        {3, 5, 3, "ready"},
        {4, 2, 3, "ready"}
    };

    std::cout << "Starting Statistic-based Process Scheduling...\n\n";

    while (true) {
        // Calculate mean difference
        double mean_difference = meanDifferenceAllPairs(processTable);
        if (mean_difference == 0) break; // all processes finished

        int index = -1;

        if (mean_difference > 2) {
            // Priority-aware LJF
            int maxPriority = -1, maxBurst = -1;
            for (int i = 0; i < processTable.size(); i++) {
                Process &p = processTable[i];
                if (p.state == "ready") {
                    if (p.priority > maxPriority || (p.priority == maxPriority && p.cpuBurst > maxBurst)) {
                        maxPriority = p.priority;
                        maxBurst = p.cpuBurst;
                        index = i;
                    }
                }
            }

            if (index != -1) {
                Process &p = processTable[index];
                p.state = "running";
                displayTable(processTable);
                std::cout << "Process " << p.pid << " is running (LJF) for " << p.cpuBurst << " units.\n\n";
                p.cpuBurst = 0;
                p.state = "finished";
            }
        }
        else if (mean_difference > 1) {
            // Priority-aware SJF
            int maxPriority = -1, minBurst = INT_MAX;
            for (int i = 0; i < processTable.size(); i++) {
                Process &p = processTable[i];
                if (p.state == "ready") {
                    if (p.priority > maxPriority || (p.priority == maxPriority && p.cpuBurst < minBurst)) {
                        maxPriority = p.priority;
                        minBurst = p.cpuBurst;
                        index = i;
                    }
                }
            }

            if (index != -1) {
                Process &p = processTable[index];
                p.state = "running";
                displayTable(processTable);
                std::cout << "Process " << p.pid << " is running (SJF) for " << p.cpuBurst << " units.\n\n";
                p.cpuBurst = 0;
                p.state = "finished";
            }
        }
        else {
            // Round Robin-like: run each ready process for 1 unit
            for (int i = 0; i < processTable.size(); i++) {
                Process &p = processTable[i];
                if (p.state == "ready") {
                    p.state = "running";
                    displayTable(processTable);
                    std::cout << "Process " << p.pid << " is running (RR) for 1 unit.\n\n";
                    p.cpuBurst -= 1;
                    if (p.cpuBurst <= 0) {
                        p.cpuBurst = 0;
                        p.state = "finished";
                    } else {
                        p.state = "ready";
                    }
                }
            }
        }
    }

    std::cout << "All processes finished!\n";
    displayTable(processTable);

    return 0;
}
