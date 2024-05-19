#include <iostream>
#include <vector>
#include "Process.h"


using namespace std;

vector<int> interpolationNodesNumber = { 10, 20, 50, 100 };


int main()
{
	process("chelm.txt", interpolationNodesNumber);
	process("stale.txt", interpolationNodesNumber);
	process("hel_yeah.txt", interpolationNodesNumber);
	process("tczew_starogard.txt", interpolationNodesNumber);

}

