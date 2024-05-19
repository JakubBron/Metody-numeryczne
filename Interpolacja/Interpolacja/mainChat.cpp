#include <iostream>
#include <vector>
#include <utility>
#include <cmath>
#include <stdexcept>

#define M_PI       3.14159265358979323846

using namespace std;

class Matrix {
private:
    vector<vector<double>> data;
    size_t rows, cols;

public:
    Matrix(size_t rows, size_t cols) : rows(rows), cols(cols), data(rows, vector<double>(cols, 0.0)) {}

    double& operator()(size_t row, size_t col) {
        if (row >= rows || col >= cols) throw out_of_range("Matrix index out of range");
        return data[row][col];
    }

    const double& operator()(size_t row, size_t col) const {
        if (row >= rows || col >= cols) throw out_of_range("Matrix index out of range");
        return data[row][col];
    }

    size_t numRows() const { return rows; }
    size_t numCols() const { return cols; }

    Matrix solve(const Matrix& b) const {
        Matrix A = *this;
        Matrix B = b;
        size_t n = rows;

        for (size_t i = 0; i < n; ++i) {
            double maxEl = abs(A(i, i));
            size_t maxRow = i;
            for (size_t k = i + 1; k < n; ++k) {
                if (abs(A(k, i)) > maxEl) {
                    maxEl = abs(A(k, i));
                    maxRow = k;
                }
            }

            for (size_t k = i; k < n; ++k) {
                swap(A(maxRow, k), A(i, k));
            }
            swap(B(maxRow, 0), B(i, 0));

            for (size_t k = i + 1; k < n; ++k) {
                double c = -A(k, i) / A(i, i);
                for (size_t j = i; j < n; ++j) {
                    if (i == j) {
                        A(k, j) = 0;
                    }
                    else {
                        A(k, j) += c * A(i, j);
                    }
                }
                B(k, 0) += c * B(i, 0);
            }
        }

        Matrix x(n, 1);
        for (int i = n - 1; i >= 0; --i) {
            x(i, 0) = B(i, 0) / A(i, i);
            for (int k = i - 1; k >= 0; --k) {
                B(k, 0) -= A(k, i) * x(i, 0);
            }
        }
        return x;
    }
};

vector<double> interpolate_spline(const vector<double>& nodes, const vector<pair<double, double>>& allPoints, size_t nodesNumber) {
    size_t Nodes = allPoints.size();
    if (Nodes < 2) {
        throw invalid_argument("At least two points are required for spline interpolation.");
    }

    size_t N = 4 * (Nodes - 1);
    Matrix A(N, N);
    Matrix b(N, 1);
    Matrix x(N, 1);
    vector<double> interpolated;
    double yp = 0.0;

    A(0, 0) = 1;
    b(0, 0) = allPoints[0].second;

    double h = allPoints[1].first - allPoints[0].first;
    A(1, 0) = 1;
    A(1, 1) = h;
    A(1, 2) = h * h;
    A(1, 3) = h * h * h;
    b(1, 0) = allPoints[1].second;

    A(2, 2) = 2;
    b(2, 0) = 0;

    h = allPoints[Nodes - 1].first - allPoints[Nodes - 2].first;
    A(3, 4 * (Nodes - 2) + 2) = 2;
    A(3, 4 * (Nodes - 2) + 3) = 6 * h;
    b(3, 0) = 0;

    for (size_t i = 1; i < Nodes - 1; ++i) {
        h = allPoints[i + 1].first - allPoints[i].first;

        A(4 * i, 4 * i) = 1;
        b(4 * i, 0) = allPoints[i].second;

        A(4 * i + 1, 4 * i) = 1;
        A(4 * i + 1, 4 * i + 1) = h;
        A(4 * i + 1, 4 * i + 2) = h * h;
        A(4 * i + 1, 4 * i + 3) = h * h * h;
        b(4 * i + 1, 0) = allPoints[i + 1].second;

        A(4 * i + 2, 4 * (i - 1) + 1) = 1;
        A(4 * i + 2, 4 * (i - 1) + 2) = 2 * h;
        A(4 * i + 2, 4 * (i - 1) + 3) = 3 * h * h;
        A(4 * i + 2, 4 * i + 1) = -1;
        b(4 * i + 2, 0) = 0;

        A(4 * i + 3, 4 * (i - 1) + 2) = 2;
        A(4 * i + 3, 4 * (i - 1) + 3) = 6 * h;
        A(4 * i + 3, 4 * i + 2) = -2;
        b(4 * i + 3, 0) = 0;
    }

    x = A.solve(b);

    for (size_t i = 0; i < nodesNumber; ++i) {
        bool isPresent = false;
        for (size_t j = 0; j < Nodes - 1; ++j) {
            if (allPoints[j].first <= nodes[i] && nodes[i] <= allPoints[j + 1].first) {
                h = nodes[i] - allPoints[j].first;
                size_t j_index = 4 * j;
                yp = x(j_index, 0) + x(j_index + 1, 0) * h + x(j_index + 2, 0) * h * h + x(j_index + 3, 0) * h * h * h;
                interpolated.push_back(yp);
                isPresent = true;
                break;
            }
        }
        if (!isPresent) {
            interpolated.push_back(interpolated.empty() ? 0.0 : interpolated.back());
        }
    }

    return interpolated;
}

void printVector(const vector<double>& vec) {
    for (const auto& val : vec) {
        cout << val << " ";
    }
    cout << endl;
}

void test_linear_data() {
    vector<pair<double, double>> points = { {0.0, 4.0}, {2.0, 1.0}, {3.0, 6.0}, {4.0, 1.0} };
    vector<double> nodes = { 0.5, 1.0, 3.5 };
    vector<double> interpolated = interpolate_spline(nodes, points, nodes.size());

    cout << "Results" << endl;
    for (int i = 0; i < nodes.size(); i++)
    {
        cout << nodes[i] << " -> " << interpolated[i] << "\n";
    }
    
}


int main() {
    test_linear_data();

    return 0;
}
