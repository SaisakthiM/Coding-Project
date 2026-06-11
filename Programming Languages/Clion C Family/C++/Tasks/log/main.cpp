#include <iostream>
#include "log.hpp"

class Log {

    public:
        const int logLevelError = 0;
        const int logLevelWarning = 1;
        const int logLevelInfo = 2;

    private: 
        int m_logLevel = logLevelInfo;

    public: 
        void setLevel(int logLevel) {
            m_logLevel = logLevel;
        }
        void Warn(const char* message) {
            if (m_logLevel >= logLevelWarning) {
                std::cout << "[Warning] : " << message << std::endl;
            }
        }
        void Error(const char* message) {
            if (m_logLevel >= logLevelError) {
                std::cout << "[Error] : " << message << std::endl;
            }
        }
        void Info(const char* message) {
            if (m_logLevel >= logLevelInfo) {
                std::cout << "[Info] : " << message << std::endl;
            }
        }
};  

int main() {
    Log log;
    log.setLevel(log.logLevelInfo);
    log.Warn("Hello!");
    log.Error("Hello!");
    log.Info("Hello!");

}