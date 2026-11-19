#include "array_tasks.h"

int minmax(const int *a, size_t n, int *lo, int *hi) {
    (void)a;
    (void)n;
    (void)lo;
    (void)hi;
    return 0;
}

void transpose(size_t rows, size_t cols,
               int src[rows][cols], int dst[cols][rows]) {
    (void)src;
    (void)dst;
}

void transpose_square(size_t n, int a[n][n]) {
    (void)a;
}

void matmul(size_t m, size_t k, size_t n,
            int a[m][k], int b[k][n], long long c[m][n]) {
    (void)a;
    (void)b;
    (void)c;
}

void matmul_bt(size_t m, size_t k, size_t n,
               int a[m][k], int bt[n][k], long long c[m][n]) {
    (void)a;
    (void)bt;
    (void)c;
}
