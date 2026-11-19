#include "array_tasks.h"
#include "test_bridge.h"

#include <algorithm>
#include <climits>
#include <vector>

#include <gtest/gtest.h>

namespace {

template <typename T>
void expect_contents(const std::vector<T>& actual, const std::vector<T>& expected) {
    ASSERT_EQ(actual.size(), expected.size());
    const auto diff = std::mismatch(actual.begin(), actual.end(), expected.begin());
    if (diff.first != actual.end()) {
        ADD_FAILURE() << "At index " << (diff.first - actual.begin())
                      << ": expected " << *diff.second << ", got " << *diff.first;
    }
}

void expect_minmax(const std::vector<int>& a, int min, int max) {
    int lo = 0, hi = 0;
    ASSERT_EQ(minmax(a.data(), a.size(), &lo, &hi), 1);
    EXPECT_EQ(lo, min);
    EXPECT_EQ(hi, max);
}

TEST(MinMax, EmptyLeavesOutputsUnchanged) {
    int lo = -15, hi = 17;
    EXPECT_EQ(minmax(nullptr, 0, &lo, &hi), 0);
    EXPECT_EQ(lo, -15);
    EXPECT_EQ(hi, 17);
}

TEST(MinMax, SingletonAndEqualElements) {
    expect_minmax({INT_MIN}, INT_MIN, INT_MIN);
    expect_minmax({7, 7, 7, 7}, 7, 7);
}

TEST(MinMax, NegativeOnlyAndPositiveOnly) {
    expect_minmax({-9, -3, -6}, -9, -3);
    expect_minmax({9, 3, 6}, 3, 9);
}

TEST(MinMax, MillionElementsWithExtremesAtEdges) {
    std::vector<int> a(1'048'579);
    for (size_t i = 0; i < a.size(); ++i)
        a[i] = static_cast<int>(i % 2001) - 1000;
    a.front() = INT_MAX;
    a.back() = INT_MIN;
    expect_minmax(a, INT_MIN, INT_MAX);
    std::swap(a.front(), a.back());
    expect_minmax(a, INT_MIN, INT_MAX);
}

void expect_transpose(size_t rows, size_t cols, std::vector<int> src,
                      const std::vector<int>& expected) {
    const auto original = src;
    std::vector<int> dst(src.size(), INT_MIN);
    test_transpose(rows, cols, src.data(), dst.data());
    expect_contents(dst, expected);
    expect_contents(src, original);
}

TEST(Transpose, RectangularAndSingleton) {
    expect_transpose(2, 3, {1, -2, 3, 4, 0, 6}, {1, 4, -2, 0, 3, 6});
    expect_transpose(1, 1, {42}, {42});
}

TEST(Transpose, SingleRowAndSingleColumn) {
    expect_transpose(1, 5, {-7, 0, 1, 99, 2}, {-7, 0, 1, 99, 2});
    expect_transpose(5, 1, {1, 3, 5, 7, 9}, {1, 3, 5, 7, 9});
}

int pattern(size_t i, size_t j) {
    return static_cast<int>((31 * i + 163 * j + (i ^ j)) % 1021) - 510;
}

TEST(Transpose, LargeOddRectangle) {
    constexpr size_t rows = 1025, cols = 769;
    std::vector<int> src(rows * cols), expected(rows * cols);
    for (size_t i = 0; i < rows; ++i)
        for (size_t j = 0; j < cols; ++j)
            src[i * cols + j] = pattern(i, j);
    for (size_t pos = 0; pos < expected.size(); ++pos)
        expected[pos] = pattern(pos % rows, pos / rows);
    expect_transpose(rows, cols, src, expected);
}

TEST(TransposeSquare, SingletonAndAsymmetricTwoByTwo) {
    std::vector<int> unit{42}, a{0, -2, 7, 4};
    test_transpose_square(1, unit.data());
    test_transpose_square(2, a.data());
    expect_contents(unit, {42});
    expect_contents(a, {0, 7, -2, 4});
}

TEST(TransposeSquare, LargeOddSquareAndRoundTrip) {
    constexpr size_t n = 513;
    std::vector<int> a(n * n), expected(n * n);
    for (size_t pos = 0; pos < a.size(); ++pos) {
        a[pos] = pattern(pos / n, pos % n);
        expected[pos] = pattern(pos % n, pos / n);
    }
    const auto original = a;
    test_transpose_square(n, a.data());
    expect_contents(a, expected);
    test_transpose_square(n, a.data());
    expect_contents(a, original);
}

class Matmul : public ::testing::TestWithParam<bool> {
protected:
    void expect_product(size_t m, size_t k, size_t n, const std::vector<int>& a,
                        const std::vector<int>& b, const std::vector<long long>& expected) {
        const bool transposed = GetParam();
        auto lhs = a, rhs = b;
        if (transposed) {
            for (size_t pos = 0; pos < rhs.size(); ++pos)
                rhs[pos] = b[(pos % k) * n + pos / k];
        }
        const auto original_rhs = rhs;
        std::vector<long long> out(m * n, LLONG_MIN);
        test_matmul(m, k, n, lhs.data(), rhs.data(), out.data(), transposed);
        expect_contents(out, expected);
        expect_contents(lhs, a);
        expect_contents(rhs, original_rhs);
    }
};

TEST_P(Matmul, RectangularWithThreeDifferentDimensions) {
    expect_product(2, 3, 4, {1, 2, 3, -1, 0, 4},
                   {2, 0, 1, 4, 1, -2, 2, 0, 3, 4, 0, -1},
                   {13, 8, 5, 1, 10, 16, -1, -8});
}

TEST_P(Matmul, DotProductOuterProductAndScalar) {
    expect_product(1, 3, 1, {2, -3, 4}, {3, 2, -1}, {-4});
    expect_product(3, 1, 2, {2, -3, 0}, {5, -2}, {10, -4, -15, 6, 0, 0});
    expect_product(1, 1, 1, {-7}, {-3}, {21});
}

TEST_P(Matmul, IdentityAndZeroOverwriteOutput) {
    expect_product(2, 2, 3, {1, 0, 0, 1}, {1, 2, 3, 7, 0, -4},
                   {1, 2, 3, 7, 0, -4});
    expect_product(2, 2, 3, {0, 0, 0, 0}, {1, 2, 3, 7, 0, -4},
                   {0, 0, 0, 0, 0, 0});
}

TEST_P(Matmul, ProductAndAccumulatorUseWideType) {
    expect_product(1, 1, 1, {50000}, {50000}, {2500000000LL});
    expect_product(1, 3, 1, {30000, 30000, 30000}, {30000, 30000, 30000},
                   {2700000000LL});
}

TEST_P(Matmul, LargeDenseRectangleWithAnalyticalResult) {
    constexpr size_t m = 193, k = 257, n = 131;
    std::vector<int> a(m * k), b(k * n);
    std::vector<long long> expected(m * n);
    auto u = [](size_t i) { return static_cast<int>(i % 13) - 6; };
    auto v = [](size_t t) { return static_cast<int>(t % 7) - 3; };
    auto w = [](size_t t) { return static_cast<int>(t % 11) - 5; };
    auto z = [](size_t j) { return static_cast<int>(j % 17) - 8; };
    long long dot = 0;
    for (size_t t = 0; t < k; ++t)
        dot += v(t) * w(t);
    for (size_t i = 0; i < m; ++i)
        for (size_t t = 0; t < k; ++t)
            a[i * k + t] = u(i) * v(t);
    for (size_t t = 0; t < k; ++t)
        for (size_t j = 0; j < n; ++j)
            b[t * n + j] = w(t) * z(j);
    for (size_t i = 0; i < m; ++i)
        for (size_t j = 0; j < n; ++j)
            expected[i * n + j] = u(i) * dot * z(j);
    expect_product(m, k, n, a, b, expected);
}

INSTANTIATE_TEST_SUITE_P(Direct, Matmul, ::testing::Values(false));
INSTANTIATE_TEST_SUITE_P(Transposed, Matmul, ::testing::Values(true));

}
