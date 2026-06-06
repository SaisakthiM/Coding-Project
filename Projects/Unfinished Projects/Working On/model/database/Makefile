CXX      = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -g
TARGET   = dbserver
SRC      = src/main.cpp

$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SRC)

clean:
	rm -f $(TARGET)
