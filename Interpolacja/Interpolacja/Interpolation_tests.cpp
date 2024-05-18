#include "Interpolation_tests.h"
#include "Interpolation.h"


void test_interpolate_lagrange()
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

void test_interpolate_spline()
{
	std::cout << "test_interpolate_lagrange(): \n";
	vector<double> nodes = { -1.0, 1.0, 5.0 };
	size_t nodesNumber = nodes.size();
	vector< pair<double, double> > allPoints = {
		{0.0,4.0}, {2.0,1.0}, {3.0,6.0}, {4.0,1.0}
	};
	vector<double> expectedResult = { 33.5, -3.25, -24.75 };

	vector<double> interpolationResult = interpolate_spline(nodes, allPoints, nodesNumber);

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