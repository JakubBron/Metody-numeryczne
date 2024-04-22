#include <iostream>
#include <cmath>
#include "Matrix.h"

using namespace std;

void taskAB(int N)
{
	// task A & B
	Matrix A(N, N);
	A.fillMainDiagonal(5 + 2);
	A.fillSecondDiagonals(-1);
	A.fillThirdDiagonals(-1);

	Matrix b(N, 1);
	for (int i = 0; i < N; i++)
	{
		b(i, 0) = sin((i + 1) * 2);
	}

	//cout << A << "\n";
	//cout << b << "\n";

	Matrix x = A.jacobi(b);
	std::cout << "Jacobi solution: \n" << x << "\n";


	Matrix xG = A.gaussSeidel(b);
	std::cout << "Gauss soluton: \n" << xG << "\n";
}

void taskC(int N)
{
	Matrix b(N, 1);
	for (int i = 0; i < N; i++)
	{
		b(i, 0) = sin((i + 1) * 2);
	}

	Matrix Ac(N, N);
	Ac.fillMainDiagonal(3);
	Ac.fillSecondDiagonals(-1);
	Ac.fillThirdDiagonals(-1);

	Matrix x1 = Ac.jacobi(b);
	std::cout << "Jacobi solution: \n" << x1 << "\n";
	Matrix xG1 = Ac.gaussSeidel(b);
	std::cout << "Gauss soluton: \n" << xG1 << "\n";
}

void taskD(int N)
{
	Matrix L(N, N);
	Matrix U(N, N);

	Matrix b(N, 1);
	for (int i = 0; i < N; i++)
	{
		b(i, 0) = sin((i + 1) * 2);
	}

	Matrix Ac(N, N);
	Ac.fillMainDiagonal(3);
	Ac.fillSecondDiagonals(-1);
	Ac.fillThirdDiagonals(-1);

	Ac.luDecomposition(L, U);

	std::cout << "Matrix L: " << L << "\n";
	std::cout << "Matrix U: " << U << "\n";
}

int main()
{
	int N = 908;

	// #####################################################

						N = 10;

	// ########################################################

	/*Matrix A(2, 2);
	A(0, 0) = 2;	A(0, 1) = 1;
	A(1, 0) = 5;	A(1, 1) = 7;
	Matrix b(2, 1);
	b(0, 0) = 11;	b(1, 0) = 13;
	Matrix x = A.jacobi(b);
	std::cout << "Solution: \n" << x;*/

	/*Matrix A(2, 2);
	A(0, 0) = 2;	A(0, 1) = 1;
	A(1, 0) = 5;	A(1, 1) = 7;
	Matrix b(2, 1);
	b(0, 0) = 11;	b(1, 0) = 13;
	Matrix x = A.gaussSeidel(b);
	std::cout << "Solution: \n" << x << "\n";*/

	/*Matrix A(3, 3);
	A(0, 0) = 1; A(0, 1) = 2; A(0, 2) = 4;
	A(1, 0) = 3; A(1, 1) = 8; A(1, 2) = 14;
	A(2, 0) = 2; A(2, 1) = 6; A(2, 2) = 13;

	Matrix L(3, 3);
	Matrix U(3, 3);

	A.luDecomposition(L, U);
	std::cout << "L: " << L << "\n";
	std::cout << "U: " << U << "\n";*/



	//taskAB(N);
	//taskC(N);
	//taskD(N);

	return 0;
}