#include <stdio.h>

int main(void)
{
    unsigned int n;
    unsigned int result = 0U;

    if (scanf("%u", &n) != 1) {
        return 1;
    }

    unsigned int x = n;
    unsigned int previous = x % 10U;
    unsigned int current = 0U;

    do {
        unsigned int digit = x % 10U;

        if (digit == previous) {
            ++current;
        } else {
            current = 1U;
        }

        if (current > result) {
            result = current;
        }

        previous = digit;
        x /= 10U;
    } while (x != 0U);

    printf("%u\n", result);
    return 0;
}
