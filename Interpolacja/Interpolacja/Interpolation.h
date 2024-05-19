#define _USE_MATH_DEFINES
#include <math.h>
#include "Matrix.h"

using namespace std;

vector<double> interpolate_lagrange(const vector<double>& nodes_x, const vector<double>& nodes_y, const vector<pair<double, double> >& allPoints, size_t nodesNumber)
{
	/*
	* This function interpolates function f(x). 'nodes' helpful to calculate coefficients.
	* For every 'x' in 'allPoints' we're gonna calc F(x).
	*/

	vector<double> interpolated;
	double yp = 0.0;
	double p = 1.0;
	double xp = 0.0;
	for (int k=0; k<allPoints.size(); k++)
	{
		xp = allPoints[k].first;
		yp = 0.0;
		p = 1.0;
		// calculating Lagrange polynomial value for 'xp'
		for (int i = 0; i < nodes_x.size(); i++)
		{
			p = 1.0;
			// creating Lagrange polynomial phi_i(xp) = multiply(1, n+1, (xp - x_j)/(x_i - x_j) if i != j)
			for (int j = 0; j < nodes_x.size(); j++)
			{
				if (i != j)
				{
					if (abs(nodes_x[i] - nodes_x[j]) <= 0.000001)
					{
						p *= 1.0;
					}
					else
					{
						p = p * (xp - nodes_x[j]) / (nodes_x[i] - nodes_x[j]);
					}
				}
			}
			// F(x) = sum(y_i*phi_i(xp))
			yp += p*nodes_y[i];
		}
		interpolated.push_back(yp);
	}
	return interpolated;
}

vector<double> interpolate_spline(const vector<double>& nodes, const vector<pair<double, double> >& allPoints, size_t nodesNumber)
{
	/*
	*	In general, S_i(x) = a_i+b_i*x+c_i*x^2+d_i*x^3
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
	size_t N = 4*(Nodes - 1);			
	Matrix A(N, N);
	Matrix b(N, 1);
	Matrix x(N, 1);		// here will be stored all coefficients
	vector<double> interpolated;
	double yp = 0.0;

	// S_0(x_0) = a_0 = y_0 <=> a0 = y0
	A(0, 0) = 1;
	b(0, 0) = allPoints[0].second;

	// S_0(x_1) = y_1 <=> a0+b0*h+c0*h^2+d0*h^3 = y1
	double h = allPoints[1].first - allPoints[0].first;
	A(1, 0) = 1;
	A(1, 1) = h;
	A(1, 2) = h*h;
	A(1, 3) = h*h*h;		// <=> h*h*h
	b(1, 0) = allPoints[1].second;

	// S''_0(x0) = 0
	A(2, 2) = 1;
	b(2, 0) = 0;

	// S''_{n-1}(x_n) = 0
	h = allPoints[Nodes - 1].first - allPoints[Nodes - 2].first;
	A(3, 4*(Nodes - 2)+2) = 2;
	A(3, 4*(Nodes - 2)+3) = 6*h;
	b(3, 0) = 0;

	for (int i = 1; i < Nodes-1; i++)
	{
		h = allPoints[i].first - allPoints[i - 1].first;

		// S_i(x_i) = y_i
		A(4*i, 4*i) = 1;
		b(4*i, 0) = allPoints[i].second;

		// S_i( x_i+1 ) = y_i+1
		A(4*i+1, 4*i) = 1;
		A(4*i+1, 4*i+1) = h;
		A(4*i+1, 4*i+2) = h*h;
		A(4*i+1, 4*i+3) = h*h*h ;
		b(4*i+1, 0) = allPoints[i+1].second;

		// S'_i(x_i) = S'_{ i - 1 }(x_i)
		A(4*i+2, 4*(i - 1)+1) = 1;
		A(4*i+2, 4*(i - 1)+2) = 2*h;
		A(4*i+2, 4*(i - 1)+3) = 3*h*h;
		A(4*i+2, 4*i+1) = -1;
		b(4*i+2, 0) = 0;

		// S''_i(x_i) = S''_{ i - 1 }(x_i)
		A(4*i+3, 4*(i - 1)+2) = 2;
		A(4*i+3, 4*(i - 1)+3) = 6*h;
		A(4*i+3, 4*i+2) = -2;
		b(4*i+3, 0) = 0;
	}

	x = A.solve(b);
	bool isPresent = false;
	for (int i = 0; i < nodesNumber; i++)
	{
		isPresent = false;
		for (int j = 0; j < Nodes-1; j++)
		{
			if (allPoints[j].first <= nodes[i] && nodes[i] <= allPoints[j+1].first)
			{
				h = nodes[i] - allPoints[j].first;
				int j_ = 4*j;
				yp = x(j_, 0) + x(j_+1, 0)*h + x(j_+2, 0)*h*h + x(j_+3, 0)*h*h*h;
				interpolated.push_back(yp);
				isPresent = true;
				break;
			}
		}
		if (!isPresent)
		{
			interpolated.push_back( interpolated.size()==0 ? 0.0 : interpolated[interpolated.size()-1] );
		}
	}

	return interpolated;
}


vector<double> linspace(double startVal, double endVal, size_t number)
{
	vector<double> result;
	double step = (endVal - startVal) / (number - 1);
	for (int i = 0; i < number; i++)
	{
		result.push_back(startVal + step * i);
	}
	return result;
}

vector<double> chebyshev(double startVal, double endVal, size_t number)
{
	vector<double> result;
	double a = (startVal + endVal) / 2.0;
	double b = (startVal - endVal) / 2.0;
	double t = 0.0;
	for (int i = 0; i < number; i++)
	{
		t = a + b * cos(M_PI * (2.0 * double(i) + 1.0) / (2.0 * double(number) ));
		result.push_back(t);
	}
	return result;
}

void test_linspace()
{
	cout << "test_linspace(): \n";
	vector<pair <double, double> > allData;
	size_t n = 20, k = 5;
	cout << "Dataset: \n";
	for (int i = 0; i < n; i++)
	{
		allData.push_back({ 10.0 * i + sin(i), 21.37 * i + cos(i) });
		cout << allData[i].first << " " << allData[i].second << "\n";
	}

	vector<double> linspace_test = linspace(allData[0].first, allData[allData.size() - 1].first, k);

	cout << "Returned: \n";
	for (int i = 0; i < linspace_test.size(); i++)
	{
		cout << linspace_test[i] << "\n";
	}
}

void test_chebyshev()
{
	cout << "test_chebyshev(): \n";
	vector<pair <double, double> > allData;
	size_t n = 20, k = 5;
	cout << "Dataset: \n";
	for (int i = 0; i < n; i++)
	{
		allData.push_back({ 10.0 * i + sin(i), 21.37 * i + cos(i) });
		cout << allData[i].first << " " << allData[i].second << "\n";
	}

	vector<double> chebyshev_test = chebyshev(allData[0].first, allData[allData.size() - 1].first, k);

	cout << "Returned: \n";
	for (int i = 0; i < chebyshev_test.size(); i++)
	{
		cout << chebyshev_test[i] << "\n";
	}
}


/*void test_interpolate_lagrange()
{
	std::cout << "test_interpolate_lagrange(): \n";
	vector<double> nodes = { -1.0, 1.0, 5.0 };
	size_t nodesNumber = nodes.size();
	vector< pair<double, double> > allPoints = {
		{0.0,4.0}, {2.0,1.0}, {3.0,6.0}, {4.0,1.0}
	};
	vector<double> expectedResult = { 33.5, -3.25, -24.75 };

	vector<double> interpolationResult = interpolate_lagrange(nodes, allPoints, nodesNumber);

	if (expectedResult.size() == interpolationResult.size())
	{
		std::cout << "Expected vs interpolated: \n";
		for (int i = 0; i < expectedResult.size(); i++)
		{
			std::cout << expectedResult[i] << " vs " << interpolationResult[i] << "\n";
		}
	}
	else
	{
		std::cout << "Different sizes! Expected: " << expectedResult.size() << "; received: " << interpolationResult.size() << "\n";
	}
}
*/
/*
void test_interpolate_spline()
{
	std::cout << "test_interpolate_spline(): \n";
	vector<double> nodes = {0.5, 1.0, 3.5 };
	size_t nodesNumber = nodes.size();
	vector< pair<double, double> > allPoints = {
		{0.0,0.0}, {2.0,10.0}, {3.0,7.0}, {4.0,16.5}
	};
	vector<double> expectedResult = { 0.25, 1.0, 12.25 };

	vector<double> interpolationResult = interpolate_spline(nodes, allPoints, nodesNumber);

	if (expectedResult.size() == interpolationResult.size())
	{
		std::cout << "Expected vs interpolated: \n";
		for (int i = 0; i < expectedResult.size(); i++)
		{
			std::cout << "x = " << nodes[i] << ": " << expectedResult[i] << " vs " << interpolationResult[i] << "\n";
		}
	}
	else
	{
		std::cout << "Different sizes! Expected: " << expectedResult.size() << "; received: " << interpolationResult.size() << "\n";
	}
}
*/