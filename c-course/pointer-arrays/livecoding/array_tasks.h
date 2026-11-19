#ifndef ARRAY_TASKS_H
#define ARRAY_TASKS_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

int minmax(const int *a, size_t n, int *lo, int *hi);

#ifdef __cplusplus
}
#else
void transpose(size_t rows, size_t cols,
               int src[rows][cols], int dst[cols][rows]);
void transpose_square(size_t n, int a[n][n]);
void matmul(size_t m, size_t k, size_t n,
            int a[m][k], int b[k][n], long long c[m][n]);
void matmul_bt(size_t m, size_t k, size_t n,
               int a[m][k], int bt[n][k], long long c[m][n]);
#endif

#endif
