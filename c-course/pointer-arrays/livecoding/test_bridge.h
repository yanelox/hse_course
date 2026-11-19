#ifndef TEST_BRIDGE_H
#define TEST_BRIDGE_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

void test_transpose(size_t rows, size_t cols, int *src, int *dst);
void test_transpose_square(size_t n, int *flat);
void test_matmul(size_t m, size_t k, size_t n, int *a, int *right,
                 long long *out, int right_is_transposed);

#ifdef __cplusplus
}
#endif

#endif
