// gcc -O0 -fno-omit-frame-pointer -S stack_frame/frame_example.c -fno-asynchronous-unwind-tables -fno-unwind-tables -o frame_example.s -masm=intel -m32

#include <stdio.h>

int compute() {
    int a = 2;
    int b = 1;
    int c = a * b;
    int d = c + a;
    int e = d / (b + 1);

    return a + b + c + d + e;
}

int main() {
    int result = compute();
    printf("Result: %d\n", result);
    return 0;
}