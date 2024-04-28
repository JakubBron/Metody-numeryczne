import numpy as np
import matplotlib.pyplot as plt

# load data from txt file
data = np.loadtxt('E_gauss_error.txt')
data2 = np.loadtxt('E_jacobi_error.txt')
data3 = np.loadtxt('E_lu_error.txt')


# plot Gauss-Seidel and Jacobi on one graph
x = [100, 500, 1000, 2000, 3000]
plt.plot(x, data, label='Gauss-Seidel')
plt.plot(x, data2, label='Jacobi')
plt.plot(x, data3, label='LU')
#plt.plot(data, label='Gauss-Seidel')
#plt.plot(data2, label='Jacobi')
plt.legend()
#plt.yscale('log')
#plt.xlabel('ietracja')
plt.xlabel('N')
#plt.ylabel('błąd')
plt.ylabel('Czas [s]')
#plt.title('Wartość błędu w kolejnych iteracjach')
plt.title('Czas potrzebny każdej z metod do obliczenia wyniku')
plt.show()

