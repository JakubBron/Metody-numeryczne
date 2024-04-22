#include <iostream>
#include <vector>
#include <stdexcept>
#include <cmath>
#include <chrono>
#include <fstream>

class Matrix {
private:
    std::vector<std::vector<double>> data;
    size_t rows;
    size_t cols;

public:
    // Constructor
    Matrix(size_t rows, size_t cols) : rows(rows), cols(cols), data(rows, std::vector<double>(cols, 0)) {}

    // Copy constructor
    Matrix(const Matrix& other) : rows(other.rows), cols(other.cols), data(other.data) {}

    // Assignment operator
    Matrix& operator=(const Matrix& other) {
        if (this != &other) {
            rows = other.rows;
            cols = other.cols;
            data = other.data;
        }
        return *this;
    }

    // Access operator
    double& operator()(size_t row, size_t col) {
        if (row >= rows || col >= cols) {
            throw std::out_of_range("Matrix indices out of range");
        }
        return data[row][col];
    }

    // Addition operator
    Matrix operator+(const Matrix& other) const {
        if (rows != other.rows || cols != other.cols) {
            throw std::invalid_argument("Matrices must have the same dimensions");
        }
        Matrix result(rows, cols);
        for (size_t i = 0; i < rows; ++i) {
            for (size_t j = 0; j < cols; ++j) {
                result(i, j) = data[i][j] + other.data[i][j];
            }
        }
        return result;
    }

    // Subtraction operator
    Matrix operator-(const Matrix& other) const {
        if (rows != other.rows || cols != other.cols) {
            throw std::invalid_argument("Matrices must have the same dimensions");
        }
        Matrix result(rows, cols);
        for (size_t i = 0; i < rows; ++i) {
            for (size_t j = 0; j < cols; ++j) {
                result(i, j) = data[i][j] - other.data[i][j];
            }
        }
        return result;
    }

    // Multiplication operator
    Matrix operator*(const Matrix& other) const {
        if (cols != other.rows) {
            throw std::invalid_argument("Number of columns in first matrix must equal number of rows in second matrix");
        }
        Matrix result(rows, other.cols);
        for (size_t i = 0; i < rows; ++i) {
            for (size_t j = 0; j < other.cols; ++j) {
                for (size_t k = 0; k < cols; ++k) {
                    result(i, j) += data[i][k] * other.data[k][j];
                }
            }
        }
        return result;
    }

    int getCols()
    {
        return cols;
    }

    int getRows() {
        return rows;
    }


    double norm() {
        double ans = 0;
        for (size_t i = 0; i < rows; i++)
        {
            for (size_t j = 0; j < cols; j++)
            {
                ans += (data[i][j] * data[i][j]);
            }
        }
        return sqrt(ans);
    }

    void fillMainDiagonal(double value) {
        if (rows != cols) {
            throw std::invalid_argument("Matrix must be square");
        }
        for (size_t i = 0; i < rows; ++i) {
            data[i][i] = value;
        }
    }

    void fillSecondDiagonals(double value) {
        if (rows != cols) {
            throw std::invalid_argument("Matrix must be square");
        }
        for (size_t i = 0; i < rows; ++i) {
            if (i > 0) data[i - 1][i] = value;     // Diagonal below main
            if (i < rows - 1) data[i + 1][i] = value; // Diagonal above main
        }
    }

    void fillThirdDiagonals(double value) {
        if (rows != cols) {
            throw std::invalid_argument("Matrix must be square");
        }
        for (size_t i = 0; i < rows; ++i) {
            if (i > 1) data[i - 2][i] = value;     // Diagonal below second
            if (i < rows - 2) data[i + 2][i] = value; // Diagonal above second
        }
    }

    // Output operator
    friend std::ostream& operator<<(std::ostream& os, const Matrix& matrix) {
        os << "Matrix " << matrix.rows << " x " << matrix.cols << "\n[";
        for (size_t i = 0; i < matrix.rows; ++i) {
            for (size_t j = 0; j < matrix.cols; ++j) {
                os << matrix.data[i][j] << ' ';
            }
            os << std::endl;
        }
        os << "]\n";
        return os;
    }


    Matrix jacobi(Matrix& b, double tolerance = 1e-9) const {
        if (rows != cols || rows != b.getRows()) {
            throw std::invalid_argument("Matrix and vector dimensions must match");
        }

        Matrix x(rows, 1);
        Matrix xNew(rows, 1);
        size_t iterations = 0;
        double error = 21372137;
        std::vector<double> errorCollection;

        auto startTime = std::chrono::high_resolution_clock::now();

        while (error > tolerance) {
            for (size_t i = 0; i < rows; ++i) {
                double sum = 0;
                for (size_t j = 0; j < cols; ++j) {
                    if (i != j) {
                        sum += data[i][j] * x(j, 0);
                    }
                }
                xNew(i, 0) = (b(i, 0) - sum) / data[i][i];
            }

            Matrix errorMatrix = (*this) * x - b;
            error = errorMatrix.norm();
            errorCollection.push_back(error);

            x = xNew;
            iterations++;
        }
        auto endTime = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(endTime - startTime);


        std::cout << "Jacobi! \n";
        std::cout << "Iterations: " << iterations << "\n";
        std::cout << "Used time: " << double(duration.count())/1000 << " ms \n";

        std::ofstream file;
        file.open("jacobi_error.txt");
        for (int i = 0; i < errorCollection.size(); i++)
        {
            file << errorCollection[i] << "\n";
        }
        file.close();

        return x;
    }

    Matrix gaussSeidel(Matrix& b, double tolerance = 1e-9) const {
        if (rows != cols || rows != b.getRows()) {
            throw std::invalid_argument("Matrix and vector dimensions must match");
        }

        Matrix x(rows, 1); // Initial guess
        Matrix xNew(rows, 1);
        size_t iterations = 0;
        double error = 21372137;
        std::vector<double> errorCollection;

        auto startTime = std::chrono::high_resolution_clock::now();
        while (error > tolerance) {
            for (int i = 0; i < rows; i++)
            {
                double sum1 = 0, sum2 = 0;
                for (int j = 0; j < i; j++)
                {
                    sum1 += (data[i][j] * xNew(j, 0));
                }
                for (int j = i + 1; j < rows; j++)
                {
                    sum2 += (data[i][j] * x(j, 0));
                }
                xNew(i, 0) = (b(i, 0) - sum1 - sum2)/data[i][i];
            }
            x = xNew;
            Matrix residual = (*this) * x - b;
            error = residual.norm();
            errorCollection.push_back(error);

            iterations++;
        }
        auto endTime = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(endTime - startTime);


        std::cout << "Gauss-Seidel! \n";
        std::cout << "Iterations: " << iterations << "\n";
        std::cout << "Used time: " << double(duration.count()) / 1000 << " ms \n";

        std::ofstream file;
        file.open("gauss_error.txt");
        for (int i = 0; i < errorCollection.size(); i++)
        {
            file << errorCollection[i] << "\n";
        }
        file.close();

        return x;
    }

    void luDecomposition(Matrix& L, Matrix& U) const {
        if (rows != cols) {
            throw std::invalid_argument("Matrix must be square for LU factorization");
        }

        for (size_t i = 0; i < rows; ++i) {
            L(i, i) = 1.0;  // Diagonal of L is 1
            for (size_t j = i; j < cols; ++j) {
                double sum = 0;
                for (size_t k = 0; k < i; ++k) {
                    sum += L(i, k) * U(k, j);
                }
                U(i, j) = data[i][j] - sum;
            }
            for (size_t j = i + 1; j < rows; ++j) {
                double sum = 0;
                for (size_t k = 0; k < i; ++k) {
                    sum += L(j, k) * U(k, i);
                }
                L(j, i) = (data[j][i] - sum) / U(i, i);
            }
        }
    }
};