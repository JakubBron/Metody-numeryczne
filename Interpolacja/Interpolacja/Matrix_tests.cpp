#include <iostream>
#include "Matrix.h"
#include "Matrix_tests.h"

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
