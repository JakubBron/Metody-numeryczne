#pragma once
#include "Matrix.h"

using namespace std;

vector<double> interpolate_lagrange(const vector<double>& nodes, const vector<pair<double, double> >& allPoints, size_t nodesNumber)
{
	/*
	* This function interpolates function f(x). For every 'x' from interpolation nodes ('nodes') calculates value
	* of interpolated function F(x) in each 'x' in 'nodes'.
	*/

	vector<double> interpolated;
	double yp = 0.0;
	double p = 1.0;
	double xp = 0.0;
	for (int k=0; k<nodesNumber; k++)
	{
		xp = nodes[k];
		yp = 0.0;
		// calculating Lagrange polynomial value for 'xp'
		for (int i = 0; i < allPoints.size(); i++)
		{
			p = 1.0;
			// creating Lagrange polynomial phi_i(xp) = multiply(1, n+1, (xp - x_j)/(x_i - x_j) if i != j)
			for (int j = 0; j < allPoints.size(); j++)
			{
				if (i != j)
				{
					p = p * (xp - allPoints[j].first) / (allPoints[i].first - allPoints[j].first);
				}
			}
			// F(x) = sum(y_i * phi_i(xp))
			yp += p * allPoints[i].second;
		}
		interpolated.push_back(yp);
	}
	return interpolated;
}

vector<double> interpolate_spline(const vector<double>& nodes, const vector<pair<double, double> >& allPoints, size_t nodesNumber)
{
	/*
	*	In general, S_i(x) = a_i + b_i * x + c_i * x^2 + d_i * x^3
	*	Where a_1 ... d_i not known (matrix 'x')
	*	Matrix 'A' stores 'x'-es standing next to coefficients (known, in allPoints.first)
	*	Matrix 'b' stores 'y'-es which is a value of f(x_i) = y_i (known, in allPoints.second)
	* 
	*	From lecture, we know that:
	*	1. In nodes S_0 and S_1 fixed values; S_0(x_0) = y_0, S_0(x_1) = y_1, S_1(x_0) = y_1, S_1(x_1) = y_2
	*	2. Second derivatives are equal 0; S''_n-1(x_0) = 0 and S''_0(x_n) = 0
	*	3. Derivatives of internal nodes are equal; S'_k(x_k) = S'_k-1(x_k) and S''_k(x_k) = S''_k-1(x_k)
	*	
	*/


	size_t Nodes = allPoints.size();	// number of subsets
	size_t N = 4 * (Nodes - 1);			
	Matrix A(N, N);
	Matrix b(N, 1);
	Matrix x(N, 1);		// here will be stored all coefficients
	vector<double> interpolated;
	double yp = 0.0;

	// S_0(x_0) = a_0 = y_0 <=> a0 = y0
	A(0, 0) = 1;
	b(0, 0) = allPoints[0].second;

	// S_0(x_1) = y_1 <=> a0 + b0 * h + c0 * h^2 + d0 * h^3 = y1
	double h = allPoints[1].first - allPoints[0].first;
	A(1, 0) = 1;
	A(1, 1) = h;
	A(1, 2) = h * h;
	A(1, 3) = A(1,2) * h;		// <=> h*h*h
	b(1, 0) = allPoints[1].second;

	// S''_0(x0) = 0
	A(2, 2) = 1;
	b(2, 0) = 0;

	// S''_{n-1}(x_n) = 0
	h = allPoints[Nodes - 1].first - allPoints[Nodes - 2].first;
	A(3, 4 * (Nodes - 2) + 2) = 2;
	A(3, 4 * (Nodes - 2) + 3) = 6 * h;
	b(3, 0) = 0;

	for (int i = 1; i < Nodes; i++)
	{
		h = allPoints[i].first - allPoints[i - 1].first;

		// S_i(x_i) = y_i
		A(4 * i, 4 * i) = 1;
		b(4 * i, 0) = allPoints[i].second;

		// S_i( x_i+1 ) = y_i+1
		A(4 * i + 1, 4 * i) = 1;
		A(4*i+1, 4 * i + 1) = h;
		A(4 * i + 1, 4 * i + 2) = h * h;
		A(4 * i + 1, 4 * i + 3) = h*h*h ;
		b(4 * i + 1, 0) = allPoints[i+1].second;

		// S'_i(x_i) = S'_{ i - 1 }(x_i)
		A(4 * i + 2, 4 * (i - 1) + 1) = 1;
		A(4 * i + 2, 4 * (i - 1) + 2) = 2 * h;
		A(4 * i + 2, 4 * (i - 1) + 3) = 3 * h * h;
		A(4 * i + 2, 4 * i + 1) = -1;
		b(4 * i + 2, 0) = 0;

		// S''_i(x_i) = S''_{ i - 1 }(x_i)
		A(4 * i + 3, 4 * (i - 1) + 2) = 2;
		A(4 * i + 3, 4 * (i - 1) + 3) = 6 * h;
		A(4 * i + 3, 4 * i + 2) = -2;
		b(4 * i + 3, 0) = 0;
	}

	x = A.solve(b);
	bool isPresent = false;
	for (int i = 0; i < nodesNumber; i++)
	{
		isPresent = false;
		for (int j = 0; j < Nodes; j++)
		{
			if (allPoints[j].first <= i && i <= allPoints[j + 1].first)
			{
				h = i - allPoints[j].first;
				j = 4 * j;
				yp = x(j, 0) + x(j + 1, 0) * h + x(j + 2, 0) * h * h + x(j + 3, 0) * h * h * h;
				interpolated.push_back(yp);
				isPresent = true;
				break;
			}
		}
		if (!isPresent)
		{
			interpolated.push_back(interpolated[interpolated.size() - 1]);
		}
	}

	return interpolated;
}