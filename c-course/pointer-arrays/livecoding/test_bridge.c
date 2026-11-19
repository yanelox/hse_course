#include "array_tasks.h"
#include "test_bridge.h"

#include <stdlib.h>
#include <string.h>

static void *alloc(size_t rows, size_t row_size) {
    void *p = malloc(rows * row_size);
    if (p == NULL)
        abort();
    return p;
}

static void copy_input(size_t rows, size_t cols, int matrix[rows][cols],
                       const int *flat) {
    for (size_t i = 0; i < rows; ++i)
        memcpy(matrix[i], flat + i * cols, sizeof(int[cols]));
}

static void copy_output(size_t rows, size_t cols, int matrix[rows][cols],
                        int *flat) {
    for (size_t i = 0; i < rows; ++i)
        memcpy(flat + i * cols, matrix[i], sizeof(int[cols]));
}

void test_transpose(size_t rows, size_t cols, int *src, int *dst) {
    int (*src2d)[cols] = alloc(rows, sizeof(int[cols]));
    int (*dst2d)[rows] = alloc(cols, sizeof(int[rows]));
    copy_input(rows, cols, src2d, src);
    copy_input(cols, rows, dst2d, dst);

    transpose(rows, cols, src2d, dst2d);

    copy_output(rows, cols, src2d, src);
    copy_output(cols, rows, dst2d, dst);
    free(dst2d);
    free(src2d);
}

void test_transpose_square(size_t n, int *flat) {
    int (*a)[n] = alloc(n, sizeof(int[n]));
    copy_input(n, n, a, flat);
    transpose_square(n, a);
    copy_output(n, n, a, flat);
    free(a);
}

void test_matmul(size_t m, size_t k, size_t n, int *a, int *right,
                 long long *out, int right_is_transposed) {
    int (*lhs)[k] = alloc(m, sizeof(int[k]));
    long long (*c)[n] = alloc(m, sizeof(long long[n]));
    copy_input(m, k, lhs, a);
    for (size_t i = 0; i < m; ++i)
        memcpy(c[i], out + i * n, sizeof(long long[n]));

    if (right_is_transposed) {
        int (*bt)[k] = alloc(n, sizeof(int[k]));
        copy_input(n, k, bt, right);
        matmul_bt(m, k, n, lhs, bt, c);
        copy_output(n, k, bt, right);
        free(bt);
    } else {
        int (*b)[n] = alloc(k, sizeof(int[n]));
        copy_input(k, n, b, right);
        matmul(m, k, n, lhs, b, c);
        copy_output(k, n, b, right);
        free(b);
    }

    copy_output(m, k, lhs, a);
    for (size_t i = 0; i < m; ++i)
        memcpy(out + i * n, c[i], sizeof(long long[n]));
    free(c);
    free(lhs);
}
