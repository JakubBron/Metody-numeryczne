from matplotlib import pyplot as plt
import numpy as np
import os

def dataset_chelm(numberOfNodes, choosingType, datasetName):
    path = f'data/{datasetName}.txt'
    f = open(path, 'r')
    rawdata = f.read().split('\n')
    f.close()

    if choosingType != "all":
        path = f'interpolated/interpolated_{datasetName}.txt_{str(numberOfNodes)}_{choosingType}.txt'
        f = open(path, 'r')
        rawdataInterpolated = f.read().split('\n')
        f.close()

        path = f'interpolated/interpolated_{datasetName}.txt_{str(numberOfNodes)}_{choosingType}_NODES.txt'
        f = open(path, 'r')
        rawdataNodes = f.read().split('\n')
        f.close()

    length = []
    elevation = []
    lengthInterpolated = []
    elevationInterpolated = []
    nodes_X = []
    nodes_Y = []
    for record in rawdata:
        # dataset is a list of lists, which contains "pairs": length, elevation
        length.append(float(record.split()[0]))
        elevation.append(float(record.split()[1]))
    
    if choosingType != "all":
        for record in rawdataInterpolated:
            lengthInterpolated.append(float(record.split()[0]))
            elevationInterpolated.append(float(record.split()[1]))

        for record in rawdataNodes:
            nodes_X.append(float(record.split()[0]))
            nodes_Y.append(float(record.split()[1]))
    
    
    # make plot 
    if choosingType == "all":
        text = f"'{datasetName}' dataset, length vs elevation. Original"
        plt.title(text)
    else:
        text = f"'{datasetName}' dataset, length vs elevation. Number of nodes: {numberOfNodes}, {choosingType}"
        plt.title(text)
    
    
    plt.semilogy(length, elevation, label="Original data")
    if choosingType != "all":
        plt.semilogy(lengthInterpolated, elevationInterpolated, label="Interpolated data")
        plt.semilogy(nodes_X, nodes_Y, '.', color='red', label="Selected nodes")
    plt.legend()
    plt.xlabel("Length [m]")
    plt.ylabel("Elevation (log) [m]")    
    if choosingType == "all":
        path = f"plots/{datasetName}_" + choosingType + "_nodes.png"
        plt.savefig(path)
    else:
        path = f"plots/{datasetName}_" + str(numberOfNodes) + "_" + choosingType + ".png"
        plt.savefig(path)
    
    plt.show()


def main():
    numberOfNodes = [10, 20, 50, 100]
    choosingTypes = ["linspace", "chebyshev", "spline"]
    if not os.path.exists("plots"):
        os.makedirs("plots")
    datasetNames = ["chelm", "stale", "hel_yeah", "tczew_starogard"]
    
    for datasetName in datasetNames:
        dataset_chelm(-1, "all", datasetName)

        for nodes in numberOfNodes:
            dataset_chelm(nodes, choosingTypes[0], datasetName)
        
        for nodes in numberOfNodes:
            dataset_chelm(nodes, choosingTypes[1], datasetName)
        
        for nodes in numberOfNodes:
            dataset_chelm(nodes, choosingTypes[2], datasetName)
    

main()