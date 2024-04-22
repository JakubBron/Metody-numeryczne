import numpy as np
import matplotlib.pyplot as plt

# load data from txt file
data = np.loadtxt('gauss_error.txt')
data2 = np.loadtxt('jacobi_error.txt')

# plot
# plot Gauss-Seidel and Jacobi on one graph
plt.plot(data, label='Gauss-Seidel')
plt.plot(data2, label='Jacobi')
plt.legend()
plt.yscale('log')
plt.xlabel('Iteration')
plt.ylabel('Error')
plt.title('Error of Gauss-Seidel / Jacobi vs Iteration')
plt.show()

