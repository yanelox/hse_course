#include "array_tasks.h"

int minmax(const int *a, size_t n, int *lo, int *hi) {
    if (n == 0)
        return 0;

    int min = a[0], max = a[0];
    for (size_t i = 1; i < n; ++i) {
        if (a[i] < min)
            min = a[i];
        if (a[i] > max)
            max = a[i];
    }
    *lo = min;
    *hi = max;
    return 1;
}

void transpose(size_t rows, size_t cols,
               int src[rows][cols], int dst[cols][rows]) {
    for (size_t i = 0; i < rows; ++i)
        for (size_t j = 0; j < cols; ++j)
            dst[j][i] = src[i][j];
}

void transpose_square(size_t n, int a[n][n]) {
    for (size_t i = 0; i < n; ++i) {
        for (size_t j = i + 1; j < n; ++j) {
            int tmp = a[i][j];
            a[i][j] = a[j][i];
            a[j][i] = tmp;
        }
    }
}

void matmul(size_t m, size_t k, size_t n,
            int a[m][k], int b[k][n], long long c[m][n]) {
    for (size_t i = 0; i < m; ++i) {
        for (size_t j = 0; j < n; ++j) {
            long long sum = 0;
            for (size_t t = 0; t < k; ++t)
                sum += (long long)a[i][t] * b[t][j];
            c[i][j] = sum;
        }
    }
}

void matmul_bt(size_t m, size_t k, size_t n,
               int a[m][k], int bt[n][k], long long c[m][n]) {
    for (size_t i = 0; i < m; ++i) {
        for (size_t j = 0; j < n; ++j) {
            long long sum = 0;
            for (size_t t = 0; t < k; ++t)
                sum += (long long)a[i][t] * bt[j][t];
            c[i][j] = sum;
        }
    }
}
