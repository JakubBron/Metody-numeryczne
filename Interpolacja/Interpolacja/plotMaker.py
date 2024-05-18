from matplotlib import pyplot as plt
import numpy as np
import os

def mylinspace(length, elevation, numberOfNodes):
    indexes = np.linspace(0, len(length)-1, numberOfNodes)
    newLength = []
    newElevation = []
    for index in indexes:
        newLength.append(length[int(index)])
        newElevation.append(elevation[int(index)])
    
    return newLength, newElevation

def chebyshev(length, elevation, numberOfNodes):
    # generate real Chebyshev nodes
    realChebyshev = []
    begin = 0
    end = len(length) - 1
    for i in range(numberOfNodes):
        c = (begin + end) / 2 + (end - begin) / 2 * np.cos((2 * i + 1) / (2 * numberOfNodes) * np.pi)
        realChebyshev.append(c)


    # from data, find nodes which are closest to real Chebyshev nodes
    newLength = []
    newElevation = []
    for c in realChebyshev:
        indexClosest = -1
        for i in range(len(length)):
            if indexClosest == -1 or abs(c - length[i]) < abs(c - length[indexClosest]):
                indexClosest = i
        newLength.append(length[indexClosest])
        newElevation.append(elevation[indexClosest])
    
    """
    print("Real Chebyshev nodes vs best found: \n")
    for i in range(len(realChebyshev)):
        print(i, ": ", realChebyshev[i], newLength[i])
    """
    return newLength, newElevation, realChebyshev

def dataset_chelm(numberOfNodes, choosingType):
    f = open('data/chelm.txt', 'r')
    rawdata = f.read().split('\n')
    f.close()

    length = []
    elevation = []
    chebyshevNodes = []
    for record in rawdata:
        # dataset is a list of lists, which contains "pairs": length, elevation
        length.append(float(record.split()[0]))
        elevation.append(float(record.split()[1]))
    
    if choosingType == "linspace":
        length, elevation = mylinspace(length, elevation, numberOfNodes)
    elif choosingType == "chebyshev":
        length, elevation, chebyshevNodes = chebyshev(length, elevation, numberOfNodes)
    elif choosingType != "all":
        print("Invalid choosingType. Choose either 'linspace' or 'chebyshev'.")
        return
    
    # make plot 
    if choosingType == "all":
        plt.title("Chelm dataset, length vs elevation. Original")
    else:
        plt.title("Chelm dataset, length vs elevation. Number of nodes: " + str(numberOfNodes) + ", " + choosingType)
    
    if choosingType == "chebyshev":
        plt.scatter(chebyshevNodes, elevation, color='red')
        plt.scatter(length, elevation, color='green')
        plt.legend(["Calculated Chebyshev nodes", "Selected nodes"])
    
    plt.plot(length, elevation)
    plt.xlabel("Length [m]")
    plt.ylabel("Elevation [m]")    
    if choosingType == "all":
        plt.savefig("plots/chelm_" + choosingType + "_nodes.png")
    else:
        plt.savefig("plots/chelm_" + str(numberOfNodes) + "_nodes_" + choosingType + ".png")
    
    plt.show()

def dataset_helyeah(numberOfNodes, choosingType):
    f = open('data/hel_yeah.txt', 'r')
    rawdata = f.read().split('\n')
    f.close()

    length = []
    elevation = []
    chebyshevNodes = []
    for record in rawdata:
        # dataset is a list of lists, which contains "pairs": length, elevation
        length.append(float(record.split()[0]))
        elevation.append(float(record.split()[1]))
    
    if choosingType == "linspace":
        length, elevation = mylinspace(length, elevation, numberOfNodes)
    elif choosingType == "chebyshev":
        length, elevation, chebyshevNodes = chebyshev(length, elevation, numberOfNodes)
    elif choosingType != "all":
        print("Invalid choosingType. Choose either 'linspace' or 'chebyshev'.")
        return
    
    # make plot 
    if choosingType == "all":
        plt.title("Hel_yeah dataset, length vs elevation. Original")
    else:
        plt.title("Hel_yeah dataset, length vs elevation. Number of nodes: " + str(numberOfNodes) + ", " + choosingType)
    
    if choosingType == "chebyshev":
        plt.scatter(chebyshevNodes, elevation, color='red')
        plt.scatter(length, elevation, color='green')
        plt.legend(["Calculated Chebyshev nodes", "Selected nodes"])
    
    plt.plot(length, elevation)
    plt.xlabel("Length [m]")
    plt.ylabel("Elevation [m]")    
    if choosingType == "all":
        plt.savefig("plots/hel_yeah_" + choosingType + "_nodes.png")
    else:
        plt.savefig("plots/hel_yeah_" + str(numberOfNodes) + "_nodes_" + choosingType + ".png")
    
    plt.show()

def dataset_GlebiaChallengera(numberOfNodes, choosingType):
    f = open('data/GlebiaChallengera.txt', 'r')
    rawdata = f.read().split('\n')
    f.close()

    length = []
    elevation = []
    chebyshevNodes = []
    for record in rawdata:
        # dataset is a list of lists, which contains "pairs": length, elevation
        length.append(float(record.split()[0]))
        elevation.append(float(record.split()[1]))
    
    if choosingType == "linspace":
        length, elevation = mylinspace(length, elevation, numberOfNodes)
    elif choosingType == "chebyshev":
        length, elevation, chebyshevNodes = chebyshev(length, elevation, numberOfNodes)
    elif choosingType != "all":
        print("Invalid choosingType. Choose either 'linspace' or 'chebyshev'.")
        return
    
    # make plot 
    if choosingType == "all":
        plt.title("GlebiaChallengera dataset, length vs elevation. Original")
    else:
        plt.title("GlebiaChallengera dataset, length vs elevation. Number of nodes: " + str(numberOfNodes) + ", " + choosingType)
    
    if choosingType == "chebyshev":
        plt.scatter(chebyshevNodes, elevation, color='red')
        plt.scatter(length, elevation, color='green')
        plt.legend(["Calculated Chebyshev nodes", "Selected nodes"])
    
    plt.plot(length, elevation)
    plt.xlabel("Length [m]")
    plt.ylabel("Elevation [m]")    
    if choosingType == "all":
        plt.savefig("plots/GlebiaChallengera_" + choosingType + "_nodes.png")
    else:
        plt.savefig("plots/GlebiaChallengera_" + str(numberOfNodes) + "_nodes_" + choosingType + ".png")
    
    plt.show()

def dataset_tczew_starogard(numberOfNodes, choosingType):
    f = open('data/tczew_starogard.txt', 'r')
    rawdata = f.read().split('\n')
    f.close()

    length = []
    elevation = []
    chebyshevNodes = []
    for record in rawdata:
        # dataset is a list of lists, which contains "pairs": length, elevation
        length.append(float(record.split()[0]))
        elevation.append(float(record.split()[1]))
    
    if choosingType == "linspace":
        length, elevation = mylinspace(length, elevation, numberOfNodes)
    elif choosingType == "chebyshev":
        length, elevation, chebyshevNodes = chebyshev(length, elevation, numberOfNodes)
    elif choosingType != "all":
        print("Invalid choosingType. Choose either 'linspace' or 'chebyshev'.")
        return
    
    # make plot 
    if choosingType == "all":
        plt.title("tczew_starogard dataset, length vs elevation. Original")
    else:
        plt.title("tczew_starogard dataset, length vs elevation. Number of nodes: " + str(numberOfNodes) + ", " + choosingType)
    
    if choosingType == "chebyshev":
        plt.scatter(chebyshevNodes, elevation, color='red')
        plt.scatter(length, elevation, color='green')
        plt.legend(["Calculated Chebyshev nodes", "Selected nodes"])
    
    plt.plot(length, elevation)
    plt.xlabel("Length [m]")
    plt.ylabel("Elevation [m]")    
    if choosingType == "all":
        plt.savefig("plots/tczew_starogard_" + choosingType + "_nodes.png")
    else:
        plt.savefig("plots/tczew_starogard_" + str(numberOfNodes) + "_nodes_" + choosingType + ".png")
    
    plt.show()

def main():
    
    #numberOfNodes = [10, 20, 50, 150]
    numberOfNodes = [20]
    choosingTypes = ["linspace", "chebyshev"]
    if not os.path.exists("plots"):
        os.makedirs("plots")
###################################################################################################
    # dataset: chelm.txt
    dataset_chelm(-1, "all")
    """
    for nodes in numberOfNodes:
        dataset_chelm(nodes, choosingTypes[0])
    
    for nodes in numberOfNodes:
        dataset_chelm(nodes, choosingTypes[1])
    """
    
    #dataset: hel_yeah.txt
    dataset_helyeah(-1, "all")

    #dataset: GlebiaChallengera.txt
    dataset_GlebiaChallengera(-1, "all")

    #dataset: tczew_starogard.txt
    dataset_tczew_starogard(-1, "all")

main()