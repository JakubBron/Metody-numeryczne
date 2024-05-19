#pragma once
#include "Interpolation.h"
#include "Helpers.h"

void lagrange_linspace(const vector<pair<double, double> >&dataset, const vector<double>& dataset_x, string datasetFilename, vector<int> interpolationNodesNumber)
{
	cout << "Lagrange linspace...\n";
	for (int nodesNumber : interpolationNodesNumber)
	{
		cout << "nodes = " << nodesNumber << "...";
		// choose 'nodesNumber' points => interpolation nodes
		vector<double> linspace_x = linspace(dataset[0].first, dataset[dataset.size() - 1].first, nodesNumber);
		vector<double> linspace_y;
		for (int i = 0; i < linspace_x.size(); i++)
		{
			double x = linspace_x[i];
			double delta = 1000000000.0;
			int index = -1;
			for (int j = 0; j < dataset.size(); j++)
			{
				if (delta > abs(x - dataset[j].first))
				{
					delta = abs(x - dataset[j].first);
					index = j;
				}
			}
			linspace_y.push_back(dataset[index].second);
		}

		if (linspace_x.size() != linspace_y.size())
		{
			cerr << "\n\nFATAL ERROR, different lengths! \n\n";
			return;
		}

		vector<double> interpolated_y = interpolate_lagrange(linspace_x, linspace_y, dataset, nodesNumber);
		saveToFile(dataset_x, interpolated_y, datasetFilename, nodesNumber, "linspace");
		saveToFile(linspace_x, linspace_y, datasetFilename, nodesNumber, "linspace_NODES");
		cout << " DONE! \n";
	}
	cout << "Lagrange linspace: DONE!\n";
	cout << "\n##################################################\n";
}

void lagrange_chebyshev(const vector<pair<double, double> >& dataset, const vector<double>& dataset_x, string datasetFilename, vector<int> interpolationNodesNumber)
{
	cout << "Lagrange Chebyshev...\n";
	for (int nodesNumber : interpolationNodesNumber)
	{
		cout << "nodes = " << nodesNumber << "...";
		// choose 'nodesNumber' points => interpolation nodes
		vector<double> chebyshev_x_1 = chebyshev(dataset[0].first, dataset[dataset.size() - 1].first, nodesNumber);

		vector<double> chebyshev_y, chebyshev_x;
		for (int i = 0; i < chebyshev_x_1.size(); i++)
		{
			double c = chebyshev_x_1[i];
			double delta = 1000000000.0;
			int index = -1;
			for (int j = 0; j < dataset.size(); j++)
			{
				if (delta > abs(c - dataset[j].first))
				{
					delta = abs(c - dataset[j].first);
					index = j;
				}
			}

			if (!chebyshev_x.empty())
			{
				if (abs(chebyshev_x[chebyshev_x.size() - 1] - dataset[index].first) > 0.0000001)
				{
					chebyshev_x.push_back(dataset[index].first);
					chebyshev_y.push_back(dataset[index].second);
				}
			}
			else
			{
				chebyshev_x.push_back(dataset[index].first);
				chebyshev_y.push_back(dataset[index].second);
			}
		}

		if (chebyshev_x.size() != chebyshev_y.size())
		{
			cerr << "\n\nFATAL ERROR, different lengths! \n\n";
			return;
		}

		vector<double> interpolated_y = interpolate_lagrange(chebyshev_x, chebyshev_y, dataset, nodesNumber);
		saveToFile(dataset_x, interpolated_y, datasetFilename, nodesNumber, "chebyshev");
		saveToFile(chebyshev_x, chebyshev_y, datasetFilename, nodesNumber, "chebyshev_NODES");
		cout << " DONE! \n";

	}
	cout << "Lagrange Chebyshev: DONE!\n";
	cout << "\n##################################################\n";
}

void spline(const vector<pair<double, double> >& dataset, const vector<double>& dataset_x, string datasetFilename, vector<int> interpolationNodesNumber)
{
	cout << "Spline...\n";
	for (int nodesNumber : interpolationNodesNumber)
	{
		cout << "nodes = " << nodesNumber << "...";
		// choose 'nodesNumber' points => interpolation nodes
		vector<double> spline_x = linspace(dataset[0].first, dataset[dataset.size() - 1].first, nodesNumber);
		vector<double> spline_y;
		for (int i = 0; i < spline_x.size(); i++)
		{
			double x = spline_x[i];
			double delta = 1000000000.0;
			int index = -1;
			for (int j = 0; j < dataset.size(); j++)
			{
				if (delta > abs(x - dataset[j].first))
				{
					delta = abs(x - dataset[j].first);
					index = j;
				}
			}
			spline_y.push_back(dataset[index].second);
		}

		if (spline_x.size() != spline_y.size())
		{
			cerr << "\n\nFATAL ERROR, different lengths! \n\n";
			return;
		}

		vector<double> interpolated_y = interpolate_spline(spline_x, spline_y, dataset, nodesNumber);
		saveToFile(dataset_x, interpolated_y, datasetFilename, nodesNumber, "spline");
		saveToFile(spline_x, spline_y, datasetFilename, nodesNumber, "spline_NODES");
		cout << " DONE! \n";
	}
	cout << "Spline: DONE!\n\n";
}

void process(string datasetFilename, vector<int> interpolationNodesNumber)
{
	cout << "##################################################\n";
	cout << "#        Processing " << datasetFilename << "\n";
	cout << "##################################################\n";

	vector<pair<double, double> > dataset = readFromFile(datasetFilename);
	vector<double> dataset_x;
	for (int i = 0; i < dataset.size(); i++)
	{
		dataset_x.push_back(dataset[i].first);
	}

	lagrange_linspace(dataset, dataset_x, datasetFilename, interpolationNodesNumber);
	lagrange_chebyshev(dataset, dataset_x, datasetFilename, interpolationNodesNumber);
	spline(dataset, dataset_x, datasetFilename, interpolationNodesNumber);

	cout << "\n";
}