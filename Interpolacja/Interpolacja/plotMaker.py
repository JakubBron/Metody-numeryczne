from matplotlib import pyplot as plt
import numpy as np
import os

def dataset_chelm(numberOfNodes, choosingType):
    f = open('data/chelm.txt', 'r')
    rawdata = f.read().split('\n')
    f.close()

    if choosingType != "all":
        path = f'interpolated/interpolated_chelm.txt_{str(numberOfNodes)}_{choosingType}.txt'
        f = open(path, 'r')
        rawdataInterpolated = f.read().split('\n')
        f.close()

        path = f'interpolated/interpolated_chelm.txt_{str(numberOfNodes)}_{choosingType}_NODES.txt'
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
        plt.title("Chelm dataset, length vs elevation. Original")
    else:
        plt.title("Chelm dataset, length vs elevation. Number of nodes: " + str(numberOfNodes) + ", " + choosingType)
    
    
    plt.semilogy(length, elevation, label="Original data")
    if choosingType != "all":
        plt.semilogy(lengthInterpolated, elevationInterpolated, label="Interpolated data")
        plt.semilogy(nodes_X, nodes_Y, '.', color='red', label="Selected nodes")
    plt.legend()
    plt.xlabel("Length [m]")
    plt.ylabel("Elevation (log) [m]")    
    if choosingType == "all":
        plt.savefig("plots/chelm_" + choosingType + "_nodes.png")
    else:
        plt.savefig("plots/chelm_" + str(numberOfNodes) + "_" + choosingType + ".png")
    
    plt.show()


def main():
    numberOfNodes = [10, 20, 50, 100]
    #numberOfNodes = [100]
    choosingTypes = ["linspace", "chebyshev"]
    if not os.path.exists("plots"):
        os.makedirs("plots")
###################################################################################################
    # dataset: chelm.txt
    """
    dataset_chelm(-1, "all")
    """
    
    """
    for nodes in numberOfNodes:
        dataset_chelm(nodes, choosingTypes[0])
    """
    
    for nodes in numberOfNodes:
        dataset_chelm(nodes, choosingTypes[1])
    
    
    #dataset: hel_yeah.txt
    #dataset_helyeah(-1, "all")

    #dataset: GlebiaChallengera.txt
    #dataset_GlebiaChallengera(-1, "all")

    #dataset: tczew_starogard.txt
    #dataset_tczew_starogard(-1, "all")

main()