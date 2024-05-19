#pragma once
#include <iostream>
#include <vector>
#include <utility>
#include <fstream>
#include <string>

using namespace std;

vector<pair<double, double> > readFromFile(string filename)
{
	vector<pair<double, double> > result;
	vector<pair<double, double> > error = { {-1, -1} };

	ifstream file("data/" + filename);
	if (!file.is_open())
	{
		cerr << "File " << filename << ": impossible to open!\n";
		return error;
	}

	//cout << "Filename: data/" << filename << ": \n";
	double data[2] = { 0.0, 0.0 };
	while(file >> data[0] >> data[1])
	{
		result.push_back({ data[0], data[1] });
	}
	file.close();

	return result;
}

void saveToFile(const vector<double>& toSaveX, const vector<double>& toSaveY, string datasetName, size_t nodesNumber, string interpolationType)
{
	string filename = "interpolated_" + datasetName + "_" + to_string(nodesNumber) + "_" + interpolationType+".txt";
	ofstream file;
	file.open("interpolated/" + filename);

	if (!file.is_open())
	{
		cerr << "File " << filename << ": impossible to open!\n";
		return;
	}

	for (int i = 0; i < toSaveX.size(); i++)
	{
		file << toSaveX[i] << " " << toSaveY[i];
		if (i < toSaveX.size() - 1)
		{
			file << "\n";
		}
		//cout << "Saving: " << toSaveX[i] << " " << toSaveY[i] << "\n";
	}

	file.close();
}