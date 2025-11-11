#include <iostream>
#include <vector>
typedef std::vector<int> vector;
typedef std::vector<std::vector<int>> vector2;

class Matrix {
public: 
    vector2 matrix;  // now a vector of vector<int>

    void push(const vector& row) {
        matrix.push_back(row);
    }

    void insert(int pos, const vector& row) {
        matrix.insert(matrix.begin() + pos, row);
    }

    void pop() {
        matrix.pop_back();
    }

    void erase(int pos) {
        matrix.erase(matrix.begin() + pos);
    }

    void clear() {
        matrix.clear();
    }

    int add(int row1, int col1, int row2, int col2) {
        return matrix[row1][col1] + matrix[row2][col2];
    }

    int mul(int row1, int col1, int row2, int col2) {
        return matrix[row1][col1] * matrix[row2][col2];
    }

    vector2 transpose() {
        int rows = matrix.size();
        int cols = rows > 0 ? matrix[0].size() : 0;

        vector2 transpose(cols, vector(rows));

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                transpose[j][i] = matrix[i][j];
            }
        }
        return transpose;
    }

    void print() {
        for (const auto& row : matrix) {
            for (int x : row) std::cout << x << " ";
            std::cout << std::endl;
        }
    }
};

int main() {
    Matrix m;
    m.push({10, 20, 30});
    m.push({40, 50, 60});

    m.print(); // prints the matrix

    std::cout << "Sum: " << m.add(0, 0, 1, 2) << std::endl; // 10 + 60 = 70
    std::cout << "Mul: " << m.mul(0, 1, 1, 1) << std::endl;  // 20 * 50 = 1000

    auto transposed = m.transpose();
    std::cout << "Transposed matrix:" << std::endl;
    for (const auto& row : transposed) {
        for (int x : row) std::cout << x << " ";
        std::cout << std::endl;
    std::cout << "Mul: " << m.mul(1, 1, 1, 2) << std::endl;  // 600
    }
}