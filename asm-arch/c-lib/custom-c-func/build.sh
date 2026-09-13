#!/bin/bash

set -e

gcc -m32 -c fact.c -fno-pie
nasm -f elf32 main.s
gcc -m32 -no-pie main.o fact.o -o main

rm main.o fact.o