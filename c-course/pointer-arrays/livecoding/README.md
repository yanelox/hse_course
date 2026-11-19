# Лайвкодинг: указатели и массивы

CMake ≥ 3.24, GCC или Clang с поддержкой C99 и C++17. GoogleTest устанавливается при первой настройке сборки, если не найден локально.

Из корня репозитория:

```sh
cmake -S c-course/pointer-arrays/livecoding -B build/pointer-arrays-livecoding -DCMAKE_BUILD_TYPE=Release
cmake --build build/pointer-arrays-livecoding -j
ctest --test-dir build/pointer-arrays-livecoding --output-on-failure
```

На занятии добавьте `-DUSE_STARTER=ON` к первой команде, редактируйте `starter.c` и запускайте нужный набор:

```sh
cmake --build build/pointer-arrays-livecoding -j
ctest --test-dir build/pointer-arrays-livecoding -R '^MinMax\.' --output-on-failure
```

Наборы: `MinMax`, `Transpose`, `TransposeSquare`, `Direct`, `Transposed`. Для эталонных решений — `-DUSE_STARTER=OFF`.

## Демонстрация ускорения

На сборке `Release` с готовыми реализациями:

```sh
cmake --build build/pointer-arrays-livecoding --target matmul_demo
```

Цель последовательно запускает размеры `512`, `1000` и `1024`. Замер выводит медианы пяти прогонов: прямое умножение, транспонирование `B`, умножение с готовой `Bᵀ`, суммарное время и ускорение с учётом транспонирования. Проверка совпадения результатов выполняется вне замера.

Один размер: `./build/pointer-arrays-livecoding/matmul_bench 1024`.
