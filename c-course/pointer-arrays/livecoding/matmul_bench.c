#include "array_tasks.h"

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

enum { RUNS = 5, MAX_DIM = 2048 };

static double now_ms(void) {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fputs("CPU clock unavailable\n", stderr);
        exit(EXIT_FAILURE);
    }
    return 1000.0 * t / CLOCKS_PER_SEC;
}

static int compare_double(const void *lhs, const void *rhs) {
    double x = *(const double *)lhs, y = *(const double *)rhs;
    return (x > y) - (x < y);
}

static double median(double a[RUNS]) {
    qsort(a, RUNS, sizeof(a[0]), compare_double);
    return a[RUNS / 2];
}

static size_t parse_dimension(const char *arg) {
    char *end;
    long value = strtol(arg, &end, 10);
    if (arg == end || *end != '\0' || value < 1 || value > MAX_DIM) {
        fprintf(stderr, "Expected dimension in 1..%d: %s\n", MAX_DIM, arg);
        exit(EXIT_FAILURE);
    }
    return (size_t)value;
}

static int equal(size_t n, long long a[n][n], long long b[n][n]) {
    for (size_t i = 0; i < n; ++i)
        for (size_t j = 0; j < n; ++j)
            if (a[i][j] != b[i][j])
                return 0;
    return 1;
}

int main(int argc, char *argv[]) {
    if (argc > 2) {
        fputs("Usage: matmul_bench [dimension]\n", stderr);
        return EXIT_FAILURE;
    }
    size_t n = argc == 2 ? parse_dimension(argv[1]) : 1024;
    int (*a)[n] = malloc(n * sizeof(int[n]));
    int (*b)[n] = malloc(n * sizeof(int[n]));
    int (*bt)[n] = malloc(n * sizeof(int[n]));
    long long (*direct)[n] = malloc(n * sizeof(long long[n]));
    long long (*with_bt)[n] = malloc(n * sizeof(long long[n]));
    int status = EXIT_FAILURE;
    if (!a || !b || !bt || !direct || !with_bt) {
        fputs("Cannot allocate matrices\n", stderr);
        goto cleanup;
    }
    for (size_t i = 0; i < n; ++i) {
        for (size_t j = 0; j < n; ++j) {
            a[i][j] = (int)((i * 39 + j * 13 + (i ^ j)) % 29) - 14;
            b[i][j] = (int)((i * 17 + j * 71 + (i ^ j)) % 31) - 15;
            bt[i][j] = 0;
            direct[i][j] = 0;
            with_bt[i][j] = 1;
        }
    }

    matmul(n, n, n, a, b, direct);
    transpose(n, n, b, bt);
    matmul_bt(n, n, n, a, bt, with_bt);
    if (!equal(n, direct, with_bt)) {
        fputs("Results differ\n", stderr);
        goto cleanup;
    }

    double baseline[RUNS], prepare[RUNS], multiply[RUNS], total[RUNS];
    for (size_t r = 0; r < RUNS; ++r) {
        if (r % 2 == 0) {
            double start = now_ms();
            matmul(n, n, n, a, b, direct);
            baseline[r] = now_ms() - start;
        }

        double start = now_ms();
        transpose(n, n, b, bt);
        double middle = now_ms();
        matmul_bt(n, n, n, a, bt, with_bt);
        double end = now_ms();
        prepare[r] = middle - start;
        multiply[r] = end - middle;
        total[r] = end - start;

        if (r % 2 != 0) {
            double start_direct = now_ms();
            matmul(n, n, n, a, b, direct);
            baseline[r] = now_ms() - start_direct;
        }
        if (!equal(n, direct, with_bt)) {
            fputs("Results differ\n", stderr);
            goto cleanup;
        }
    }

    const double direct_ms = median(baseline);
    const double total_ms = median(total);
    printf("%zu x %zu, median of %d CPU-time runs\n", n, n, RUNS);
    printf("direct:     %9.3f ms\n", direct_ms);
    printf("transpose:  %9.3f ms\n", median(prepare));
    printf("matmul_bt:  %9.3f ms\n", median(multiply));
    printf("total B^T:  %9.3f ms\n", total_ms);
    if (direct_ms > 0.0 && total_ms > 0.0)
        printf("speedup (including transpose): %.2fx\n", direct_ms / total_ms);
    status = EXIT_SUCCESS;

cleanup:
    free(with_bt);
    free(direct);
    free(bt);
    free(b);
    free(a);
    return status;
}
