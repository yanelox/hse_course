---
marp: true
theme: hse-course
size: 16:9
paginate: true
title: Указатели в C
---

<!-- _class: title -->
<!-- _paginate: false -->

# Указатели в C

Пробная презентация · C99

---

<!-- _footer: "[Операторы адреса и разыменования](https://en.cppreference.com/w/c/language/operator_member_access.html#Address_of)" -->

# Как изменить значение через указатель?

```c
int x = 42;
int *p = &x;

*p = 7;  // теперь x == 7
```

- `&x` берёт *адрес* объекта `x`, а `p` хранит этот адрес.
- `*p` обозначает *сам объект* `x`. Поэтому присваивание меняет `x`, а не `p`.

<!-- Вопрос группе: меняет ли операция *p = 7 значение самого указателя? -->
