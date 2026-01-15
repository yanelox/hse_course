// clang -S -masm=intel -O0 linker-example1.c -o linker-example1.s
//

int foo (int a, int b);

static int x;

int main()
{
	int a = 42;
	int b = 43;
	foo(a, b);
}