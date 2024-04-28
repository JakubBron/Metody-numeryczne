#include <iostream>
#include <cmath>
#include "Matrix.h"

using namespace std;

void taskAB(int N)
{
	// task A & B
	std::cout << "Task A & B\n";
	Matrix A(N, N);
	A.fillMainDiagonal(5 + 2);
	A.fillSecondDiagonals(-1);
	A.fillThirdDiagonals(-1);

	Matrix b(N, 1);
	for (int i = 0; i < N; i++)
	{
		b(i, 0) = sin((i+1) * (3+1));
	}

	Matrix x = A.jacobi(b);
	//std::cout << "Jacobi solution: \n" << x << "\n";


	Matrix xG = A.gaussSeidel(b);
	//std::cout << "Gauss soluton: \n" << xG << "\n";
}

void taskC(int N)
{
	std::cout << "task C\n";
	Matrix b(N, 1);
	for (int i = 0; i < N; i++)
	{
		b(i, 0) = sin((i+1) * (3+1));
	}

	Matrix Ac(N, N);
	Ac.fillMainDiagonal(3);
	Ac.fillSecondDiagonals(-1);
	Ac.fillThirdDiagonals(-1);

	Matrix x1 = Ac.jacobi(b);
	//std::cout << "Jacobi solution: \n" << x1 << "\n";
	Matrix xG1 = Ac.gaussSeidel(b);
	//std::cout << "Gauss soluton: \n" << xG1 << "\n";
}

void taskD(int N)
{
	std::cout << "task D \n";
	/*
	* Ax = b and A = L * U, so
	* L*U*x = b
	* L*y = b -> forward substitution for finding 'y', where y is a part of solve ('x').
	* U*x = y -> backward substitution for finding 'x'.
	*/

	Matrix A(N, N);
	A.fillMainDiagonal(3);
	A.fillSecondDiagonals(-1);
	A.fillThirdDiagonals(-1);

	Matrix b(N, 1);
	for (int i = 0; i < N; i++)
	{
		b(i, 0) = sin((i+1) * (3+1));
	}

	Matrix x(N, 1);
	x = A.lu(b);
	//std::cout << "LU solution: \n" << x << "\n";

}

void taskE()
{
	std::cout << "task E\n";
	int N[] = { 100, 500, 1000, 2000, 3000 };
	for (int i = 0; i < sizeof(N) / sizeof(N[0]); i++)
	{
		std::cout << "\n";
		std::cout << "N = " << N[i] << "\n";
		std::cout << "\n";
		
		Matrix A(N[i], N[i]);
		A.fillMainDiagonal(5 + 2);
		A.fillSecondDiagonals(-1);
		A.fillThirdDiagonals(-1);

		Matrix b(N[i], 1), b1(N[i], 1), b2(N[i], 1);
		for (int j = 0; j < N[i]; j++)
		{
			b(j, 0) = sin((j+1) * (3+1));
			
		}

		A.jacobi(b, true);
		A.gaussSeidel(b, true);
		A.lu(b, true);
	}
}

int main()
{
	int N = 908;

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

	/*Matrix L(3, 3);
	L(0, 0) = 1; L(0, 1) = 0; L(0, 2) = 0;
	L(1, 0) = 3; L(1, 1) = 1; L(1, 2) = 0;
	L(2, 0) = 2; L(2, 1) = 1; L(2, 2) = 1;
	Matrix b(3, 1);
	b(0, 0) = 3; b(1,0) = 13; b(2, 0) = 4;
	Matrix x(3, 1);
	
	x = x.forwardSubstitution(L, b);
	std::cout << x << "\n";*/

	/*Matrix U(3, 3);
	U(0, 0) = 1; U(0, 1) = 2; U(0, 2) = 4;
	U(1, 0) = 0; U(1, 1) = 2; U(1, 2) = 2;
	U(2, 0) = 0; U(2, 1) = 0; U(2, 2) = 3;
	Matrix y(3, 1);
	y(0, 0) = 3; y(1,0) = 4; y(2, 0) = -6;
	Matrix x(3, 1);

	x = x.backwardSubstitution(U, y);
	std::cout << x << "\n";*/

	/*Matrix A(3, 3);
	A(0, 0) = 1; A(0, 1) = 2; A(0, 2) = 4;
	A(1, 0) = 3; A(1, 1) = 8; A(1, 2) = 14;
	A(2, 0) = 2; A(2, 1) = 6; A(2, 2) = 13;
	Matrix b(3, 1);
	b(0, 0) = 3; b(1,0) = 13; b(2, 0) = 4;

	Matrix x(3, 1); 
	x = A.lu(b);
	std::cout << x << "\n";*/

	//taskAB(N);
	cout << "\n";
	taskC(N);
	cout << "\n";
	//taskD(N);
	cout << "\n";
	//taskE();
	return 0;
}