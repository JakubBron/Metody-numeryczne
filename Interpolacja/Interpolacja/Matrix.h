#include <iostream>
#include <vector>
#include <stdexcept>
#include <cmath>
#include <chrono>
#include <algorithm>

using namespace std;

class Matrix {
private:
    std::vector<double> data;
    size_t rows;
    size_t cols;

public: 
    // Constructor
    Matrix(size_t rows, size_t cols) : rows(rows), cols(cols), data(rows * cols, 0) {}

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
        return data[row*cols+col];
    }

    // Access operator
    const double& operator()(size_t row, size_t col) const {
        if (row >= rows || col >= cols) {
            throw std::out_of_range("Matrix indices out of range");
        }
        return data[row * cols + col];
    }

    // Addition operator
    Matrix operator+(const Matrix& other) const {
        if (rows != other.rows || cols != other.cols) {
            throw std::invalid_argument("Matrices must have the same dimensions");
        }
        Matrix result(rows, cols);
        for (size_t i = 0; i < rows * cols; ++i) {
            result.data[i] = data[i] + other.data[i];
        }
        return result;
    }

    // Subtraction operator
    Matrix operator-(const Matrix& other) const {
        if (rows != other.rows || cols != other.cols) {
            throw std::invalid_argument("Matrices must have the same dimensions");
        }
        Matrix result(rows, cols);
        for (size_t i = 0; i < rows * cols; ++i) {
            result.data[i] = data[i] - other.data[i];
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
                    result(i, j) += (*this)(i,k) * other(k,j);
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
                ans += ( (*this)(i,j) * (*this)(i,j) );
            }
        }
        return sqrt(ans);
    }

    void fillMainDiagonal(double value) {
        if (rows != cols) {
            throw std::invalid_argument("Matrix must be square");
        }
        for (size_t i = 0; i < rows; ++i) {
            (*this)(i,i) = value;
        }
    }

    // Output operator
    friend std::ostream& operator<<(std::ostream& os, const Matrix& matrix) {
        os << "Matrix " << matrix.rows << " x " << matrix.cols << "\n[";
        for (size_t i = 0; i < matrix.rows; ++i) {
            for (size_t j = 0; j < matrix.cols; ++j) {
                os << matrix(i,j) << ' ';
            }
            os << std::endl;
        }
        os << "]\n";
        return os;
    }

    Matrix solve(Matrix& b) const {
        /*
        * Ax = b and A = L * U, so
        * PAx = Pb
        * L*U*x = Pb
        * L*y = Pb -> forward substitution for finding 'y', where y is a part of solve ('x').
        * U*x = y -> backward substitution for finding 'x'.
        */

        if (rows != cols || cols != b.getRows()) {
            throw std::invalid_argument("Matrix and vector dimensions must match");
        }

        Matrix L(rows, cols);
        Matrix U(rows, cols);
        Matrix P(rows, cols);
        Matrix x(rows, 1);
        Matrix y(rows, 1);

        auto startTime = std::chrono::high_resolution_clock::now();

        this->luDecomposition(L, U, P);
        b = P * b;
        y = y.forwardSubstitution(L, b);
        x = x.backwardSubstitution(U, y);
        Matrix residual = (*this) * x - b;

        double error = residual.norm();
        auto endTime = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(endTime - startTime);

        std::cout << "(" << double(duration.count()) / 1000 << " s  ";
        std::cout << "error: " << error << ")";
        return x;
    }

    Matrix forwardSubstitution(Matrix& L, Matrix& b) const {
        if (L.getRows() != L.getCols() || L.getCols() != b.getRows()) {
            std::cout << "Error! \n";
            throw std::invalid_argument("Matrix and vector dimensions must match");
        }

        Matrix x(rows, 1);
        for (int i = 0; i < rows; i++)
        {
            double sum = 0.0;
            for (int j = 0; j < i; j++)
            {
                sum += (L(i, j) * x(j, 0));
            }

            x(i, 0) = (b(i, 0) - sum);
        }
        return x;
    }

    Matrix backwardSubstitution(Matrix& U, Matrix& y) const {
        if (U.getRows() != U.getCols() || U.getCols() != y.getRows()) {
            std::cout << "Error! \n";
            throw std::invalid_argument("Matrix and vector dimensions must match");
        }

        int rows = U.getRows();
        Matrix x(rows, 1);

        for (int i = rows - 1; i >= 0; i--)
        {
            double sum = 0.0;
            for (int j = i + 1; j < rows; j++)
            {
                sum += (U(i, j) * x(j, 0));
            }
            x(i, 0) = (y(i, 0) - sum) / U(i, i);
        }
        return x;
    }

    void pivot(Matrix& L, Matrix& U, Matrix& P, int i) const {
        /*cout << "pivot() gets: \n";
        cout <<"L = " << L << "\n";
        cout <<"U = "<< U << "\n";
        cout <<"P = " << P << "\n";
        cout << "i = " << i << "\n";*/
        size_t maxIndex = i;
        double maxValue = 0.0;
        for (size_t k = i; k < rows; ++k) 
        {
            if (abs(U(k, i)) > maxValue) 
            {   
                maxValue = abs(U(k, i));
                maxIndex = k;
            }
        }

        if (maxIndex != i) 
        {
            // swap rows
            for (size_t j = 0; j < cols; ++j)
            {
                std::swap(P(i, j), P(maxIndex, j));
                std::swap(U(i, j), U(maxIndex, j));
                std::swap(L(i, j), L(maxIndex, j));
            }
        }

        /*cout << "pivot() result: \n";
        cout << "L = " << L << "\n";
        cout << "U = " << U << "\n";
        cout << "P = " << P << "\n";
        cout << "i = " << i << "\n";*/
    }

    void luDecomposition(Matrix& L, Matrix& U, Matrix& P) const {
        if (rows != cols) {
            throw std::invalid_argument("Matrix must be square for LU factorization");
        }

        L.fillMainDiagonal(1.0);
        P.fillMainDiagonal(1.0);
        for (size_t i = 0; i < rows; i++)
        {
            for (size_t j = 0; j < cols; j++)
            {
                U(i, j) = (*this)(i, j);
            }
        }

        for (size_t i = 0; i < rows; ++i)
        {
            (*this).pivot(L, U, P, i);
            for (size_t j = i + 1; j < rows; j++)
            {
                L(j, i) = U(j, i) / U(i, i);
                for (size_t k = i; k < rows; k++)
                {
                    U(j, k) -= (L(j, i) * U(i, k));
                }
            }
        }
    }


    void test_decomposition()
    {
        Matrix A(3, 3);
        A(0, 0) = 1; A(0, 1) = 2; A(0, 2) = 4;
        A(1, 0) = 3; A(1, 1) = 8; A(1, 2) = 14;
        A(2, 0) = 2; A(2, 1) = 6; A(2, 2) = 13;

        Matrix L(3, 3);
        Matrix U(3, 3);
        Matrix P(3, 3);

        A.luDecomposition(L, U, P);

        std::cout << "result from luDecomposition(): \n";
        std::cout << "L: " << L << "\n";
        std::cout << "U: " << U << "\n";
        std::cout << "P: " << P << "\n";
    }

    void test_solve()
    {
        Matrix A(3, 3), c(3, 1);
        A(0, 0) = 1; A(0, 1) = 2; A(0, 2) = 4;
        A(1, 0) = 3; A(1, 1) = 8; A(1, 2) = 14;
        A(2, 0) = 2; A(2, 1) = 6; A(2, 2) = 13;
        Matrix b(3, 1), expected(3, 1);
        b(0, 0) = 3; b(1, 0) = 13; b(2, 0) = 4;
        expected(0, 0) = 3; expected(1, 0) = 4; expected(2, 0) = -2;

        c = A.solve(b);
        std::cout << "result from solve(): \n";
        std::cout << c << "\n";
        std::cout << "expected result: \n";
        std::cout << expected << "\n";
    }

};